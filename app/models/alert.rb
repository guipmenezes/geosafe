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
    results = Geocoder.search([latitude, longitude], language: 'pt-BR')
    return unless (result = results.first)

    # Extract components with multiple possible types for Brazil
    components = result.data['address_components'] || []

    street = components.find { |c| c['types'].intersect?(%w[route street_address]) }&.dig('long_name')
    neighborhood = components.find { |c| c['types'].intersect?(%w[sublocality sublocality_level_1 neighborhood]) }&.dig('long_name')
    city = components.find { |c| c['types'].include?('administrative_area_level_2') || c['types'].include?('locality') }&.dig('long_name')

    if street.present? && neighborhood.present?
      self.location = "#{street}, #{neighborhood}"
    elsif street.present? && city.present?
      self.location = "#{street}, #{city}"
    elsif result.address.present?
      self.location = result.address.split(',').first(2).map(&:strip).join(', ')
    end
  rescue StandardError => e
    Rails.logger.error "Reverse geocoding failed: #{e.message}"
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
