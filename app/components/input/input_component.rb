# frozen_string_literal: true

class Input::InputComponent < ViewComponent::Base
  def initialize(form: nil, name:, value: "", required: false, autofocus: false, autocomplete: "", label: "", password: false, placeholder: "", extra_classes: "", disabled: false, html_attributes: {})
    @form = form
    @name = name
    @value = value
    @required = required
    @autofocus = autofocus
    @autocomplete = autocomplete
    @label = label
    @extra_classes = extra_classes
    @password = password
    @placeholder = placeholder
    @disabled = disabled
    @html_attributes = html_attributes
    @errors = form&.object&.errors&.full_messages_for(name) || []
  end

  def html_options
    focus_classes = "focus:outline-none hover:border-primary-200 hover:bg-gray-1000 focus:border-primary-200"

    classes = "w-full border border-solid #{error_border_class} rounded-full text-gray-900 placeholder-gray-500 transition-all"

    unless @disabled
      classes += " " + focus_classes
    end

    options = {
      placeholder: @placeholder,
      class: classes,
      required: @required,
      disabled: @disabled,
      type: "#{type_password? ? 'password' : 'text'}"
    }.merge(@html_attributes)

    if @value.present?
      options[:value] = @value
    end

    options
  end

  def type_password?
    @password
  end

  def error_border_class
    @errors.any? ? "border-red-500" : "border-gray-200"
  end
end
