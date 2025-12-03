# frozen_string_literal: true

module AlertCard
  class AlertCardComponent < ViewComponent::Base
    def initialize(type:, alert:, location:, resident:, relevant:, inappropriate:)
      @type = type
      @alert = alert
      @location = location
      @resident = resident
      @relevant = relevant
      @inappropriate = inappropriate
      super()
    end
  end
end
