# frozen_string_literal: true

module Identity
  class EmailVerificationsController < ApplicationController
    skip_before_action :authenticate, only: :show

    before_action :set_user, only: :show

    def show
      @user.update! verified: true
      redirect_to home_path, notice: 'Obrigado por verificar seu endereço de e-mail.'
    end

    def create
      send_email_verification
      redirect_to identity_email_path, notice: 'Enviamos um e-mail de verificação para o seu endereço de e-mail.'
    end

    private

    def set_user
      @user = User.find_by_token_for!(:email_verification, params[:sid])
    rescue StandardError
      redirect_to edit_identity_email_path, alert: 'Esse link de verificação de e-mail é inválido.'
    end

    def send_email_verification
      UserMailer.with(user: Current.user).email_verification.deliver_later
    end
  end
end
