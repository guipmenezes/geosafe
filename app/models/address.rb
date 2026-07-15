# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :cep, :uf, :city, :state, :address, :number, :label, presence: true

  geocoded_by :geocoding_address
  after_validation :geocode, if: :geocoding_address_changed?
  before_save :sync_lonlat, if: -> { latitude_changed? || longitude_changed? }

  scope :within_radius, lambda { |lat, lon, km|
    where('ST_DWithin(lonlat, ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, ?)', lon, lat, km * 1000)
  }

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
    return unless results.any?

    self.latitude = results.first.latitude
    self.longitude = results.first.longitude
  end

  private

  def geocoding_address
    [address, number, city, uf, cep, 'Brasil'].compact.join(', ')
  end

  def geocoding_address_changed?
    address_changed? || number_changed? || city_changed? || uf_changed? || cep_changed?
  end

  def sync_lonlat
    self.lonlat = "POINT(#{longitude} #{latitude})" if latitude.present? && longitude.present?
  end
end
