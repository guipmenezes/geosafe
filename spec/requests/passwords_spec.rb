# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in(user)
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the password and redirects to the root url' do
        patch password_path, params: { password_challenge: 'Secret1*3*5*', password: 'NewPassword!123', password_confirmation: 'NewPassword!123' }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid password challenge' do
      it 'does not update the password and re-renders the edit template' do
        patch password_path, params: { password_challenge: 'wrong_password', password: 'NewPassword123', password_confirmation: 'NewPassword123' }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('Password challenge não é válido')
      end
    end
  end
end
