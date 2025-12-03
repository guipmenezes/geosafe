# frozen_string_literal: true

module Dropdown
  class DropdownComponent < ViewComponent::Base
    def initialize(title:, options:)
      super()
      @title = title
      @options = options
    end
  end
end
