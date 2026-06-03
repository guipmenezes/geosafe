# frozen_string_literal: true

module Identity
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate

    before_action :set_user, only: %i[edit update]

    def new; end

    def edit; end

    def create
      if (@user = User.find_by(email: params[:email], verified: true))
        send_password_reset_email
        redirect_to sign_in_path, notice: 'Verifique seu e-mail para instruções de redefinição.'
      else
        redirect_to new_identity_password_reset_path, alert: "Você não pode redefinir sua senha até verificar seu e-mail."
      end
    end

    def update
      if @user.update(user_params)
        redirect_to sign_in_path, notice: 'Sua senha foi redefinida com sucesso. Por favor, faça login.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_user
      @user = User.find_by_token_for!(:password_reset, params[:sid])
    rescue StandardError
      redirect_to new_identity_password_reset_path, alert: 'Esse link de redefinição de senha é inválido.'
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset.deliver_later
    end
  end
end
