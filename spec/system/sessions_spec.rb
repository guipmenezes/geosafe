# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by(:cuprite)
  end

  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  it 'signs in and out' do
    sign_in_as(user)
    expect(page).to have_text('Login bem sucedido!')

    click_on 'Log out'
    expect(page).to have_text('A sua sessão expirou, logout feito.')
  end

  it 'views sessions' do
    sign_in_as(user)
    click_on 'Devices & Sessions'
    expect(page).to have_selector('h1', text: 'Sessions')
  end
end
