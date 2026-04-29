# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :cep, :uf, :city, :state, :address, :number, presence: true

  geocoded_by :geocoding_address
  after_validation :geocode, if: :geocoding_address_changed?

  def full_address
    city_state = [city, uf].compact.reject(&:blank?).join(" - ")
    [address, number, city_state].compact.reject(&:blank?).join(", ")
  end

  private

  def geocoding_address
    [address, city, state, 'Brasil'].compact.join(', ')
  end

  def geocoding_address_changed?
    address_changed? || city_changed? || state_changed?
  end
end
