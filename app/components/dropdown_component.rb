# frozen_string_literal: true

class DropdownComponent < ViewComponent::Base
  def initialize(title:, options:)
    super()
    @title = title
    @options = options
  end
end
