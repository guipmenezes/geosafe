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
      {
        placeholder: @options[:placeholder],
        class: input_classes,
        required: @options[:required],
        disabled: @options[:disabled],
        type: input_type,
        autocomplete: @options[:autocomplete],
        value: @options[:value].presence || value_from_object
      }.compact.merge(@options[:html_attributes])
    end

    def value_from_object
      return nil unless @form&.object

      # Extract field name from address[label] format if necessary
      field_name = @name.to_s.match(/\[(.*)\]/) ? ::Regexp.last_match(1) : @name
      @form.object.send(field_name) if @form.object.respond_to?(field_name)
    end

    def type_password?
      @options[:password]
    end

    def error_border_class
      @errors.any? ? 'border-red-500' : 'border-grey300'
    end

    private

    def input_type
      type_password? ? 'password' : 'text'
    end

    def input_classes
      classes = ["w-full border border-solid #{error_border_class} rounded-xl text-gray-900 placeholder-grey400 transition-all py-2.5 px-4 shadow-sm"]

      classes << if @options[:disabled]
                   'opacity-50 cursor-not-allowed bg-grey100'
                 else
                   'focus:outline-none focus:ring-2 focus:ring-primary200 focus:border-primary400 hover:border-primary300'
                 end

      classes.join(' ')
    end
  end
end
