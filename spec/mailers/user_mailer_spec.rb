# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  describe 'password_reset' do
    let(:mail) { UserMailer.with(user: user).password_reset }

    it 'renders the headers' do
      expect(mail.subject).to eq('Reset your password')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['contato@geosafe.app.br'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Redefinir minha senha')
    end
  end

  describe 'email_verification' do
    let(:mail) { UserMailer.with(user: user).email_verification }

    it 'renders the headers' do
      expect(mail.subject).to eq('Verify your email')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['contato@geosafe.app.br'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Confirmar meu E-mail')
    end
  end
end
