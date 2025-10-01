# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Identity::Emails', type: :system do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in_as(user)
  end

  it 'updates the email' do
    click_on 'Change email address'

    fill_in 'New email', with: 'new_email@hey.com'
    fill_in 'Password challenge', with: 'Secret1*3*5*'
    click_on 'Save changes'

    expect(page).to have_text('Your email has been changed')
  end

  it 'sends a verification email' do
    user.update! verified: false

    click_on 'Change email address'
    click_on 'Re-send verification email'

    expect(page).to have_text('We sent a verification email to your email address')
  end
end
