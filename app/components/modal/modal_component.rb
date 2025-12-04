# frozen_string_literal: true

module Modal
  class ModalComponent < ViewComponent::Base
    renders_one :trigger

    def initialize(title:)
      super
      @title = title
    end
  end
end
