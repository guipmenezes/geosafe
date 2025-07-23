# frozen_string_literal: true

module Input
  class InputComponent < ViewComponent::Base
    DEFAULT_OPTIONS = {
      value: '',
      required: false,
      autofocus: false,
      autocomplete: '',
      label: '',
      password: false,
      placeholder: '',
      extra_classes: '',
      disabled: false,
      html_attributes: {}
    }.freeze

    def initialize(name:, form: nil, **options)
      super
      @form = form
      @name = name
      @options = DEFAULT_OPTIONS.merge(options)
      @errors = get_errors(name)
    end

    def get_errors(name)
      object = @form&.object
      object&.errors&.full_messages_for(name) || []
    end

    def html_options
      focus_classes = 'focus:outline-none hover:border-primary-200 hover:bg-gray-1000 focus:border-primary-200'

      classes = "w-full border border-solid #{error_border_class} rounded-full text-gray-900 placeholder-gray-500 transition-all"

      classes += " #{focus_classes}" unless @options[:disabled]

      options = {
        placeholder: @options[:placeholder],
        class: classes,
        required: @options[:required],
        disabled: @options[:disabled],
        type: (type_password? ? 'password' : 'text').to_s,
        autocomplete: @options[:autocomplete]
      }.merge(@options[:html_attributes])

      options[:value] = @options[:value] if @options[:value].present?

      options
    end

    def type_password?
      @options[:password]
    end

    def error_border_class
      @errors.any? ? 'border-red-500' : 'border-gray-200'
    end
  end
end
