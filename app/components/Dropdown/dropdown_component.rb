# frozen_string_literal: true

class Dropdown::DropdownComponent < ViewComponent::Base
  def initialize(title:, options:)
    super()
    @title = title
    @options = options
  end
end
