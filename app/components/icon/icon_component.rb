# frozen_string_literal: true

class Icon::IconComponent < ViewComponent::Base
    def initialize(name:, classes: "", size: "md")
        @name = name
        @classes = classes
        @size = size
    end

    def component_size
        case @size
        when "sm"
            "w-10 h-10"
        when "md"
            "w-20 h-20"
        when "lg"
            "w-24 h-24"
        end
    end
end
