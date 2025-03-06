class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      send_email_verification
      redirect_to new_address_path(user: @user), notice: "Maravilha, agora utilize o seu endereço para receber alertas da Geosafe!"
    else
      render :new, status: :unprocessable_entity, notice: "Ops, algo deu errado! Não conseguimos prosseguir com o seu cadastro."
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :username)
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
