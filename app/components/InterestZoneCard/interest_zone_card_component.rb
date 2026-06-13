# frozen_string_literal: true

class InterestZoneCard::InterestZoneCardComponent < ViewComponent::Base
  def initialize(address: nil, index:)
    @address = address
    @index = index
  end

  private

  def label
    @address&.label || "Zona de Interesse #{@index + 1}"
  end

  def full_address
    @address&.full_address || "Endereço não cadastrado"
  end

  def empty?
    @address.nil?
  end
end
