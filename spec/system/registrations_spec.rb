# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :system do
  it 'signs up' do
    visit sign_up_path

    fill_in 'user_full_name', with: 'New User'
    fill_in 'user_username', with: 'newuser'
    fill_in 'user_email', with: 'newuser@example.com'
    fill_in 'user_password', with: 'Password123!'
    fill_in 'user_password_confirmation', with: 'Password123!'
    click_on 'AVANÇAR'

    expect(page).to have_text('Maravilha, agora utilize o seu endereço para receber alertas da Geosafe!')
  end
end
