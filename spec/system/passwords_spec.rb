# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :system do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in_as(user)
  end

  it 'updates the password' do
    navigate_to_settings 'Alterar Senha'

    fill_in 'Senha Atual:', with: 'Secret1*3*5*'
    fill_in 'Nova Senha:', with: 'Secret6*4*2*'
    fill_in 'Confirmar Nova Senha:', with: 'Secret6*4*2*'
    click_on 'Salvar Alterações'

    expect(page).to have_text('Sua senha foi alterada com sucesso.')
  end
end
