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
    it 'signs the user out when deleting current session' do
      sign_in(user)
      delete session_path(user.sessions.last)
      expect(response).to redirect_to(sign_in_path)
      expect(flash[:notice]).to eq('Você saiu da sua conta com sucesso.')
    end

    it 'revokes another session without signing out' do
      sign_in(user)
      other_session = user.sessions.create!(user_agent: 'Other', ip_address: '1.2.3.4')

      delete session_path(other_session)

      expect(response).to redirect_to(sessions_path)
      expect(flash[:notice]).to eq('A sessão foi encerrada com sucesso.')
      expect(Session.exists?(other_session.id)).to be_falsey
    end
  end

  describe 'GET /sessions' do
    it 'returns http success' do
      sign_in(user)
      get sessions_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Dispositivos e Sessões')
    end
  end
end
