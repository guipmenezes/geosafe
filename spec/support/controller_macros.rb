# frozen_string_literal: true

module ControllerMacros
  def sign_in(user)
    post sign_in_path, params: { email: user.email, password: 'Secret1*3*5*' }
  end
end
