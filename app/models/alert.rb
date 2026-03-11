# frozen_string_literal: true

class Alert < ApplicationRecord
  self.inheritance_column = :_type_disabled # Disable STI

  include TypeCodes
  include AlertCodes

  belongs_to :user
  has_many :alert_votes, dependent: :destroy

  validates :alert, presence: true, inclusion: { in: [HOME, STREET] }
  validates :location, presence: true
  validates :alert_type, presence: true, inclusion: { in: [GOOD, ALERT, DANGER] }
  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, presence: true

  before_validation :set_coordinates, if: :home_alert?
  geocoded_by :location
  after_validation :geocode, if: :street_alert_and_location_changed?
  after_validation :reverse_geocode_location, if: :should_reverse_geocode?

  def user_vote(user)
    alert_votes.find_by(user: user)
  end

  def self.alert_type_options
    { 'Seguro' => GOOD, 'Atenção' => ALERT, 'Perigo' => DANGER }
  end

  def self.alert_options
    { 'Residencial' => HOME, 'Na Rua' => STREET }
  end

  def alert_type_name
    self.class.alert_type_options.key(alert_type)
  end

  def alert_name
    self.class.alert_options.key(alert)
  end

  private

  def should_reverse_geocode?
    latitude.present? && longitude.present? && (location.blank? || location.start_with?('Coordenadas:'))
  end

  def reverse_geocode_location
    result = Geocoder.search([latitude, longitude], language: 'pt-BR').first
    return unless result

    components = result.data['address_components'] || []
    street = find_address_component(components, %w[route street_address])
    neighborhood = find_address_component(components, %w[sublocality sublocality_level_1 neighborhood])
    city = find_address_component(components, %w[administrative_area_level_2 locality])

    self.location = format_location(street, neighborhood, city, result.address)
  rescue StandardError => e
    Rails.logger.error "Reverse geocoding failed: #{e.message}"
  end

  def find_address_component(components, types)
    components.find { |c| c['types'].intersect?(types) }&.dig('long_name')
  end

  def format_location(street, neighborhood, city, full_address)
    if street && neighborhood
      "#{street}, #{neighborhood}"
    elsif street && city
      "#{street}, #{city}"
    else
      full_address.to_s.split(',').first(2).map(&:strip).join(', ')
    end
  end

  def home_alert?
    alert == HOME
  end

  def street_alert_and_location_changed?
    alert == STREET && location_changed? && (latitude.blank? || longitude.blank?)
  end

  def set_coordinates
    return unless user&.address

    self.latitude = user.address.latitude
    self.longitude = user.address.longitude
  end
end
