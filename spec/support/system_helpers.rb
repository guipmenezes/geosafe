# frozen_string_literal: true

module SystemHelpers
  def sign_in_as(user)
    visit '/sign_in'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Secret1*3*5*'
    click_on 'ENTRAR'

    # Wait for login to complete and redirect to the home page
    expect(page).to have_text("Olá, #{user.full_name.split.first}")
  end
end
