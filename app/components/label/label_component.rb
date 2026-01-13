# frozen_string_literal: true

module Label
  class LabelComponent < ViewComponent::Base
    def initialize(name: nil, form: nil, text: nil, **options)
      super
      @name = name
      @form = form
      @text = text
      @options = options
      @classes = "font-medium text-md #{options[:class]}"
    end
  end
end
