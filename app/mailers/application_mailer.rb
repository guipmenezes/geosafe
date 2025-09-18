# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'contato@geosafe.com.br'
  layout 'mailer'
end
