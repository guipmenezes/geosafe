# frozen_string_literal: true

module Select
  class SelectComponent < ViewComponent::Base
    DEFAULT_OPTIONS = {
      required: false,
      label: '',
      disabled: false,
      include_blank: false,
      prompt: nil,
      selected: nil,
      extra_classes: '',
      html_attributes: {}
    }.freeze

    def initialize(name:, collection: [], form: nil, **options)
      super
      @name = name
      @collection = collection
      @form = form
      @options = DEFAULT_OPTIONS.merge(options)
      @errors = get_errors(name)
    end

    def get_errors(name)
      object = @form&.object
      object&.errors&.full_messages_for(name) || []
    end

    def html_options
      focus_classes = 'focus:outline-none hover:border-primary-200 hover:bg-gray-1000 focus:border-primary-200'

      # Using rounded-full to match InputComponent, though rounded-md is common for selects.
      # Added py-2 px-3 to ensure text is vertically centered and not squished.
      classes = "w-full border border-solid #{error_border_class} rounded-full text-gray-900 bg-white transition-all py-2 px-3"

      classes += " #{focus_classes}" unless @options[:disabled]

      options = {
        class: classes,
        required: @options[:required],
        disabled: @options[:disabled]
      }.merge(@options[:html_attributes])

      options
    end

    def error_border_class
      @errors.any? ? 'border-red-500' : 'border-gray-200'
    end

    def select_options
      opts = {}
      opts[:include_blank] = @options[:include_blank] if @options[:include_blank]
      opts[:prompt] = @options[:prompt] if @options[:prompt]
      opts[:selected] = @options[:selected] if @options[:selected]
      opts
    end
  end
end
