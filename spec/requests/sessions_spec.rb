# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  fixtures :users

  let(:user) { users(:lazaro_nixon) }

  describe 'GET /sign_in' do
    it 'returns http success' do
      get sign_in_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /sign_in' do
    context 'with valid credentials' do
      it 'signs the user in and redirects to the home url' do
        post sign_in_path, params: { email: user.email, password: 'Secret1*3*5*' }
        expect(response).to redirect_to(home_path)
        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign the user in and re-renders the new template' do
        post sign_in_path, params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unprocessable_content)
        expect(flash[:alert]).to eq('O seu e-mail ou senha estão incorretos.')
      end
    end
  end

  describe 'DELETE /sessions/:id' do
    it 'signs the user out' do
      sign_in(user)
      delete session_path(user.sessions.last)
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
