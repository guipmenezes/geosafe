# frozen_string_literal: true

module InterestZoneCard
  class InterestZoneCardComponent < ViewComponent::Base
    def initialize(index:, address: nil)
      super
      @address = address
      @index = index
    end

    private

    def label
      @address&.label || "Zona de Interesse #{@index + 1}"
    end

    def full_address
      @address&.full_address || 'Endereço não cadastrado'
    end

    def empty?
      @address.nil?
    end
  end
end
