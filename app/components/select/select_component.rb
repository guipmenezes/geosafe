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
      @collection = normalize_collection(collection)
      @form = form
      @options = DEFAULT_OPTIONS.merge(options)
      @errors = get_errors(name)
    end

    def normalize_collection(collection)
      if collection.is_a?(Hash) || begin
        collection.first.is_a?(Array)
      rescue StandardError
        false
      end
        collection.map { |label, value| { label: label, value: value } }
      else
        collection.map { |item| { label: item, value: item } }
      end
    end

    def selected_label
      label_from_collection || default_label
    end

    def selected_value
      @options[:selected] || @form&.object&.send(@name)
    end

    def error_border_class
      @errors.any? ? 'border-red-500' : 'border-grey300'
    end

    def select_options
      opts = {}
      opts[:include_blank] = @options[:include_blank] if @options[:include_blank]
      opts[:prompt] = @options[:prompt] if @options[:prompt]
      opts[:selected] = @options[:selected] if @options[:selected]
      opts
    end

    private

    def label_from_collection
      match = @collection.find { |item| item[:value].to_s == selected_value.to_s }
      match[:label] if match
    end

    def default_label
      @options[:prompt] || @options[:label] || 'Selecione...'
    end

    def get_errors(name)
      object = @form&.object
      object&.errors&.full_messages_for(name) || []
    end

    def html_options
      {
        class: select_classes,
        required: @options[:required],
        disabled: @options[:disabled]
      }.merge(@options[:html_attributes])
    end

    def select_classes
      # appearance-none to allow for custom chevron, rounded-xl for modern look
      classes = ["w-full appearance-none border border-solid #{error_border_class} " \
                 "rounded-xl text-gray-900 bg-white transition-all py-2.5 px-4 pr-10 shadow-sm"]

      classes << if @options[:disabled]
                   'opacity-50 cursor-not-allowed bg-grey100'
                 else
                   'focus:outline-none focus:ring-2 focus:ring-primary200 focus:border-primary400 hover:border-primary300'
                 end

      classes.join(' ')
    end
  end
end
