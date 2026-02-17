# frozen_string_literal: true

module Modal
  class ModalComponent < ViewComponent::Base
    renders_one :trigger

    def initialize(title:, open: false)
      super
      @title = title
      @open = open
    end

    def open?
      @open
    end
  end
end
