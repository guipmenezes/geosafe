# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get sign_up_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new user and redirects to the root url' do
        expect do
          post sign_up_path, params: { user: { full_name: 'Test Example', username: 'testexample', email: 'test@example.com', password: 'Password123!',
                                               password_confirmation: 'Password123!' } }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(new_address_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user and re-renders the new template' do
        expect do
          post sign_up_path, params: { user: { email: 'test@example.com', password: 'Password123!', password_confirmation: 'WrongPassword123!' } }
        end.to_not change(User, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
