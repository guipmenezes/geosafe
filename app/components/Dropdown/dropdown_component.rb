# frozen_string_literal: true

module Dropdown
  class DropdownComponent < ViewComponent::Base
    renders_one :trigger

    def initialize(title: nil, options: nil)
      super()
      @title = title
      @options = options
    end
  end
end
