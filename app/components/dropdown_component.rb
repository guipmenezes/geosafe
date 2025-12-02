# frozen_string_literal: true

class DropdownComponent < ViewComponent::Base
  def initialize(title:, options:)
    @title = title
    @options = options
  end
end
