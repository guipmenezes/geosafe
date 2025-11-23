# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Identity::PasswordResets', type: :system do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  it 'sends a password reset email' do
    visit sign_in_path
    click_on 'Esqueceu a sua senha?'

    fill_in 'Email', with: user.email
    click_on 'Send password reset email'

    expect(page).to have_text('Check your email for reset instructions')
  end

  it 'updates the password' do
    sid = user.generate_token_for(:password_reset)
    visit edit_identity_password_reset_path(sid: sid)

    fill_in 'New password', with: 'Secret6*4*2*'
    fill_in 'Confirm new password', with: 'Secret6*4*2*'
    click_on 'Save changes'

    expect(page).to have_text('Your password was reset successfully. Please sign in')
  end
end
