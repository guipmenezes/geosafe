# frozen_string_literal: true

module SystemHelpers
  def sign_in_as(user)
    visit '/sign_in'
    ensure_desktop_viewport

    fill_in 'email', with: user.email
    fill_in 'password', with: 'Secret1*3*5*'
    click_on 'ENTRAR'

    # Wait for login to complete and redirect to the home page
    expect(page).to have_text("Olá, #{user.full_name.split.first}", wait: 10)
  end

  private

  def ensure_desktop_viewport
    Capybara.current_session.current_window.resize_to(1200, 800)
  rescue StandardError
    # Fallback for drivers that don't support resize_to
    page.driver.resize(1200, 800) if page.driver.respond_to?(:resize)
  end
end
