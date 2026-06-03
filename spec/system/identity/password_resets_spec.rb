# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Identity::PasswordResets', type: :system do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  it 'sends a password reset email' do
    visit sign_in_path
    click_on 'Esqueceu a sua senha?'

    fill_in 'E-mail:', with: user.email
    click_on 'Enviar E-mail'

    expect(page).to have_text('Verifique seu e-mail para instruções de redefinição.')
  end

  it 'updates the password' do
    sid = user.generate_token_for(:password_reset)
    visit edit_identity_password_reset_path(sid: sid)

    fill_in 'Nova Senha:', with: 'Secret6*4*2*'
    fill_in 'Confirmar Nova Senha:', with: 'Secret6*4*2*'
    click_on 'Salvar Nova Senha'

    expect(page).to have_text('Sua senha foi redefinida com sucesso. Por favor, faça login.')
  end
end
