# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'contato@geosafe.app.br'
  layout 'mailer'
end
