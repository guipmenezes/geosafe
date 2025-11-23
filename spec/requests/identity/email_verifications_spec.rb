# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Identity::EmailVerifications', type: :request do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    user.update! verified: false
  end

  describe 'POST /create' do
    it 'sends a verification email' do
      sign_in(user)
      expect do
        post identity_email_verification_path
      end.to have_enqueued_mail(UserMailer, :email_verification).with(params: { user: user }, args: [])
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET /show' do
    it 'verifies the email' do
      sid = user.generate_token_for(:email_verification)
      get identity_email_verification_path(sid: sid, email: user.email)
      expect(user.reload.verified?).to be(true)
      expect(response).to redirect_to(root_url)
    end

    it 'does not verify with an expired token' do
      sid = user.generate_token_for(:email_verification)
      travel 3.days
      get identity_email_verification_path(sid: sid, email: user.email)
      expect(user.reload.verified?).to be(false)
      expect(response).to redirect_to(edit_identity_email_path)
      expect(flash[:alert]).to eq('That email verification link is invalid')
    end
  end
end
