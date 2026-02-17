# frozen_string_literal: true

module AlertCard
  class AlertCardComponent < ViewComponent::Base
    include Turbo::FramesHelper
    include ActionView::RecordIdentifier

    def initialize(alert:)
      super()
      @alert = alert
    end

    def type
      @alert.alert_type
    end

    def location
      @alert.location
    end

    def title
      @alert.title
    end

    def description
      @alert.description
    end

    def alert_name
      @alert.alert_name
    end

    def alert_type_name
      @alert.alert_type_name
    end

    def relevant_count
      @alert.relevant || 0
    end

    def inappropriate_count
      @alert.inappropriate || 0
    end
  end
end
