# frozen_string_literal: true

require "rails_helper"

RSpec.describe DropdownComponent, type: :component do
  let(:title) { "Options" }

  it "renders the dropdown with the correct title and options" do
    options = [
      '<a href="#">Profile</a>',
      '<a href="#">Settings</a>'
    ]
    render_inline(described_class.new(title: title, options: options))

    expect(page).to have_button(title)
    expect(page).to have_link("Profile", visible: :all)
    expect(page).to have_link("Settings", visible: :all)
  end
end