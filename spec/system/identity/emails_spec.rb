# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Identity::Emails', type: :system do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in_as(user)
  end

  it 'updates the email' do
    click_on "Olá, #{user.full_name.split.first}"
    click_on 'Alterar E-mail'

    fill_in 'Novo E-mail:', with: 'new_email@hey.com'
    fill_in 'Sua Senha Atual:', with: 'Secret1*3*5*'
    click_on 'Salvar Alterações'

    expect(page).to have_text('O seu e-mail foi alterado com sucesso.')
  end

  it 'sends a verification email' do
    user.update! verified: false

    navigate_to_settings 'Alterar E-mail'
    click_on 'Reenviar e-mail de verificação'

    expect(page).to have_text('Enviamos um e-mail de verificação para o seu endereço de e-mail.')
  end
end
