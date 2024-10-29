require 'rails_helper'

RSpec.describe Icon::IconComponent, type: :component do
  describe "rendering" do
    it "renders the correct icon" do
      result = render_inline(Icon::IconComponent.new(name: "search"))
      expect(result.css("img[src*='search_icon.svg']")).to be_present
    end

    it "applies medium size class by default" do
      result = render_inline(Icon::IconComponent.new(name: "search"))
      expect(result.css("img.w-20.h-20")).to be_present
    end

    it "applies custom classes" do
      result = render_inline(Icon::IconComponent.new(
        name: "search",
        classes: "text-red-500"
      ))
      expect(result.css("img.text-red-500")).to be_present
    end
  end

  describe "size classes" do
    it "applies small size class" do
      result = render_inline(Icon::IconComponent.new(name: "search", size: "sm"))
      expect(result.css("img.w-10.h-10")).to be_present
    end

    it "applies medium size class" do
      result = render_inline(Icon::IconComponent.new(name: "search", size: "md"))
      expect(result.css("img.w-20.h-20")).to be_present
    end

    it "applies large size class" do
      result = render_inline(Icon::IconComponent.new(name: "search", size: "lg"))
      expect(result.css("img.w-24.h-24")).to be_present
    end
  end

  describe "#component_size" do
    it "returns correct classes for each size" do
      expect(Icon::IconComponent.new(name: "search", size: "sm").component_size).to eq("w-10 h-10")
      expect(Icon::IconComponent.new(name: "search", size: "md").component_size).to eq("w-20 h-20")
      expect(Icon::IconComponent.new(name: "search", size: "lg").component_size).to eq("w-24 h-24")
    end
  end
end
