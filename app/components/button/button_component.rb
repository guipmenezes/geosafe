# frozen_string_literal: true

module Button
  class ButtonComponent < ViewComponent::Base
    def initialize(text:, **options)
      super
      @text = text
      @style = options[:style] || 'primary'
      @size = options[:size] || 'md'
      @type = options[:type] || 'button'
      assign_optional_attributes(options)
    end

    def assign_optional_attributes(options)
      @full_width = options[:full_width] || false
      @extra_classes = options[:extra_classes] || ''
      @disabled = options[:disabled] || false
      @html_attributes = options[:html_attributes] || {}
    end

    def classes
      [
        base_classes,
        size_classes,
        variant_classes,
        @full_width ? 'w-full' : '',
        @extra_classes
      ].reject(&:empty?).join(' ')
    end

    private

    def base_classes
      'inline-flex items-center justify-center font-bold tracking-wide transition-all duration-300 ' \
        'active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed disabled:active:scale-100'
    end

    def size_classes
      case @size
      when 'sm' then 'px-4 py-2 text-[11px] rounded-lg'
      when 'lg' then 'px-8 py-4 text-base rounded-2xl'
      else 'px-6 py-3 text-xs rounded-xl'
      end
    end

    def variant_classes
      case @style
      when 'secondary' then 'bg-primary50 text-primary700 hover:bg-primary100'
      when 'outline' then 'border-2 border-primary500 text-primary500 hover:bg-primary50'
      when 'danger' then 'bg-red-500 text-white hover:bg-red-600 shadow-md shadow-red-100'
      when 'ghost' then 'text-grey600 hover:bg-grey100 hover:text-grey900'
      else 'bg-primary500 text-white hover:bg-primary600 shadow-lg shadow-primary100'
      end
    end
  end
end
