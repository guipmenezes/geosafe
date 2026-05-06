# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :cep, :uf, :city, :state, :address, :number, presence: true

  geocoded_by :geocoding_address
  after_validation :geocode, if: :geocoding_address_changed?

  def full_address
    city_state = [city, uf].compact.reject(&:blank?).join(' - ')
    [address, number, city_state].compact.reject(&:blank?).join(', ')
  end

  def anonymized_address
    address_parts = [address, state].compact.reject(&:blank?).join(', ')
    [address_parts, uf].compact.reject(&:blank?).join(' - ')
  end

  def geocode_address
    results = Geocoder.search(geocoding_address)
    if results.any?
      self.latitude = results.first.latitude
      self.longitude = results.first.longitude
    end
  end

  private

  def geocoding_address
    [address, number, city, uf, cep, 'Brasil'].compact.join(', ')
  end

  def geocoding_address_changed?
    address_changed? || number_changed? || city_changed? || uf_changed? || cep_changed?
  end
end
