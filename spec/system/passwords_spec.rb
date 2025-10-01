# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :system do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in_as(user)
  end

  it 'updates the password' do
    click_on 'Change password'

    fill_in 'Password challenge', with: 'Secret1*3*5*'
    fill_in 'New password', with: 'Secret6*4*2*'
    fill_in 'Confirm new password', with: 'Secret6*4*2*'
    click_on 'Save changes'

    expect(page).to have_text('Your password has been changed')
  end
end
