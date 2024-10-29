require 'rails_helper'

RSpec.describe Logo::LogoComponent, type: :component do
  describe "rendering" do
    let(:result) { render_inline(Logo::LogoComponent.new) }

    it "renders the logo" do
      expect(result.css("h1")).to be_present
    end

    it "has the correct text" do
      expect(result).to have_text("Geo")
      expect(result).to have_text("Safe")
    end
  end
end