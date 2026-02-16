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
      base_class = 'px-6 py-2.5 font-semibold rounded-xl whitespace-nowrap transition-all duration-200 active:scale-95 shadow-sm hover:shadow-md'
      style_class = case @style
                    when 'primary' then 'bg-primary400 text-white hover:bg-primary500 focus:ring-2 focus:ring-primary200 focus:ring-offset-2'
                    when 'secondary' then 'bg-white text-primary400 border border-primary100 hover:bg-primary50 focus:ring-2 focus:ring-primary200 focus:ring-offset-2'
                    else 'bg-grey100 text-grey900 hover:bg-grey200 focus:ring-2 focus:ring-grey300 focus:ring-offset-2'
                    end
      disabled_class = @disabled ? 'opacity-50 cursor-not-allowed grayscale' : ''

      "#{base_class} #{style_class} #{disabled_class} #{@extra_classes}"
    end
  end
end
