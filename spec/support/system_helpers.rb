# frozen_string_literal: true

module SystemHelpers
  def sign_in_as(user)
    visit '/sign_in'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Secret1*3*5*'
    click_on 'ENTRAR'

    ensure_desktop_viewport
    verify_login_success(user)
  end

  private

  def verify_login_success(user)
    greeting = "Olá, #{user.full_name.split.first}"
    return if page.has_text?(greeting, wait: 5)

    handle_mobile_fallback(user)
  end

  def handle_mobile_fallback(user)
    if page.has_css?('button[data-action="click->header#toggle"]', visible: true)
      find('button[data-action="click->header#toggle"]').click
      expect(page).to have_text(user.full_name, wait: 5)
    else
      expect(page).to have_text("Olá, #{user.full_name.split.first}", wait: 10)
    end
  end

  def ensure_desktop_viewport
    page.driver.resize(1920, 1080)
  rescue StandardError
    nil
  end
end
