# frozen_string_literal: true

module SystemHelpers
  def sign_in_as(user)
    # Force resize to desktop to ensure lg: classes are active
    if page.driver.respond_to?(:resize)
      page.driver.resize(1200, 800)
    elsif page.driver.browser.respond_to?(:resize)
      page.driver.browser.resize(window_size: [1200, 800])
    end

    visit '/sign_in'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Secret1*3*5*'
    click_on 'ENTRAR'

    # Wait for login to complete and redirect to the home page
    # Using visible: true to ensure we are on desktop view
    expect(page).to have_text("Olá, #{user.full_name.split.first}", wait: 10)
  end
end
