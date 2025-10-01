# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Identity::PasswordResets', type: :request do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  describe 'GET /new' do
    it 'returns http success' do
      get new_identity_password_reset_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'sends a password reset email' do
      expect do
        post identity_password_reset_path, params: { email: user.email }
      end.to have_enqueued_mail(UserMailer, :password_reset).with(params: { user: user }, args: [])
      expect(response).to redirect_to(sign_in_path)
    end

    it 'does not send a password reset email to a nonexistent email' do
      expect do
        post identity_password_reset_path, params: { email: 'nonexistent@example.com' }
      end.to_not have_enqueued_mail(UserMailer, :password_reset)
      expect(response).to redirect_to(new_identity_password_reset_path)
      expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
    end

    it 'does not send a password reset email to an unverified email' do
      user.update!(verified: false)
      expect do
        post identity_password_reset_path, params: { email: user.email }
      end.to_not have_enqueued_mail(UserMailer, :password_reset)
      expect(response).to redirect_to(new_identity_password_reset_path)
      expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      sid = user.generate_token_for(:password_reset)
      get edit_identity_password_reset_path(sid: sid)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /update' do
    it 'updates the password' do
      sid = user.generate_token_for(:password_reset)
      patch identity_password_reset_path, params: { sid: sid, password: 'NewPassword!123', password_confirmation: 'NewPassword!123' }
      expect(response).to redirect_to(sign_in_path)
    end

    it 'does not update the password with an expired token' do
      sid = user.generate_token_for(:password_reset)
      travel 30.minutes
      patch identity_password_reset_path, params: { sid: sid, password: 'NewPassword123', password_confirmation: 'NewPassword123' }
      expect(response).to redirect_to(new_identity_password_reset_path)
      expect(flash[:alert]).to eq('That password reset link is invalid')
    end
  end
end
