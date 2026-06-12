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

    navigate_to_settings 'Sair'
    expect(page).to have_text('Você saiu da sua conta com sucesso.')
  end

  it 'views sessions' do
    sign_in_as(user)
    navigate_to_settings 'Sessões'
    expect(page).to have_selector('h1', text: 'Dispositivos e Sessões')
  end
end
