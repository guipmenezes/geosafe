# frozen_string_literal: true

module SystemHelpers
  def sign_in_as(user)
    @current_user = user
    visit '/sign_in'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Secret1*3*5*'
    click_on 'ENTRAR'
  end

  def navigate_to_settings(section)
    if page.has_css?('button[data-action="click->header#toggle"]', visible: true)
      # Mobile flow
      find('button[data-action="click->header#toggle"]').click
    else
      # Desktop flow
      greeting = "Olá, #{@current_user.full_name.split.first}"
      click_on greeting
    end

    click_on section
  end
end
