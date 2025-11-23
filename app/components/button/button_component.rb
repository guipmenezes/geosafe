# frozen_string_literal: true

module Button
  class ButtonComponent < ViewComponent::Base
    def initialize(text:, **options)
      super
      @text = text
      @style = options[:style] || 'primary'
      @type = options[:type] || 'button'
      @extra_classes = options[:extra_classes] || ''
      @disabled = options[:disabled] || false
      @html_attributes = options[:html_attributes] || {}
    end

    def classes
      base_class = 'px-4 py-2 font-semibold py-2 sm:py-1 rounded-lg whitespace-nowrap'
      style_class = case @style
                    when 'primary' then 'bg-primary400 text-white'
                    when 'secondary' then 'bg-white text-primary400'
                    else 'bg-white text-black'
                    end
      disabled_class = @disabled ? 'opacity-50 cursor-not-allowed' : ''

      "#{base_class} #{style_class} #{disabled_class} #{@extra_classes}"
    end
  end
end
