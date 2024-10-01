# frozen_string_literal: true

class Icon::IconComponent < ViewComponent::Base
    def initialize(name:, classes: "")
        @name = name
        @classes = classes
    end

    def svg_path
        case @name
        when "location"
            "app/assets/images/location_icon.svg"
        when "group"
            "app/assets/images/group_icon.svg"
        when "search"
            "app/assets/images/search_icon.svg"
        when "money"
            "app/assets/images/money_icon.svg"
        end
    end
end
