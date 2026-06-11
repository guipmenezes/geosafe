# frozen_string_literal: true

module SystemHelpers
  def sign_in_as(user)
    visit '/sign_in'

    fill_in 'email', with: user.email
    fill_in 'password', with: 'Secret1*3*5*'
    click_on 'ENTRAR'

    # Ensure we are on desktop resolution and wait for UI to update
    ensure_desktop_viewport

    # Wait for login to complete and redirect to the home page
    expect(page).to have_text("Olá, #{user.full_name.split.first}", wait: 15)
  end

  private

  def ensure_desktop_viewport
    # Resize to a safe desktop resolution
    page.driver.resize(1920, 1080)

    # Wait until mobile-only elements (lg:hidden) disappear
    # This ensures the lg: breakpoint is active and desktop elements are visible
    page.has_no_css?('.lg\\:hidden', wait: 10)
  rescue StandardError
    nil
  end
end
