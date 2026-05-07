# frozen_string_literal: true

class Alert < ApplicationRecord
  self.inheritance_column = :_type_disabled # Disable STI

  include TypeCodes
  include AlertCodes

  belongs_to :user
  has_many :alert_votes, dependent: :destroy

  validates :alert, presence: true, inclusion: { in: [HOME, STREET] }
  validates :location, presence: true, if: :street_alert?
  validates :alert_type, presence: true, inclusion: { in: [GOOD, ALERT, DANGER] }
  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validate :user_has_address, if: :home_alert?

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

  def home_alert?
    alert == HOME
  end

  def street_alert?
    alert == STREET
  end

  def as_json_for_map
    {
      id: id,
      latitude: latitude,
      longitude: longitude,
      title: title,
      description: description,
      location: location,
      alert_name: alert_name,
      alert_type_name: alert_type_name,
      alert_type: alert_type,
      creator_name: user.full_name,
      date: I18n.l(created_at, format: :short)
    }
  end

  private

  def user_has_address
    if user&.address.nil?
      errors.add(:base, 'Você precisa ter um endereço cadastrado para criar um alerta residencial.')
    else
      # Try to geocode if coordinates are missing
      user.address.geocode_address if user.address.latitude.blank? || user.address.longitude.blank?

      if user.address.latitude.blank? || user.address.longitude.blank?
        errors.add(:base, 'Seu endereço cadastrado não pôde ser localizado no mapa. Por favor, verifique se o CEP e o número estão corretos.')
      end
    end
  end

  def should_reverse_geocode?
    street_alert? && latitude.present? && longitude.present? && (location.blank? || location.start_with?('Coordenadas:'))
  end

  def reverse_geocode_location
    result = Geocoder.search([latitude, longitude], language: 'pt-BR').first
    return unless result

    data = extract_address_components(result.data['address_components'] || [])
    self.location = format_location(data, result.address)
  rescue StandardError => e
    Rails.logger.error "Reverse geocoding failed: #{e.message}"
  end

  def extract_address_components(components)
    {
      street: find_address_component(components, %w[route street_address]),
      neighborhood: find_address_component(components, %w[sublocality sublocality_level_1 neighborhood]),
      city: find_address_component(components, %w[administrative_area_level_2 locality]),
      state: find_address_component(components, %w[administrative_area_level_1], 'short_name')
    }
  end

  def find_address_component(components, types, field = 'long_name')
    components.find { |c| c['types'].intersect?(types) }&.dig(field)
  end

  def format_location(data, fallback)
    # Priority 1: Locality information (Neighborhood, City)
    locality_parts = [data[:neighborhood], data[:city]].compact.uniq
    return locality_parts.join(', ') if locality_parts.any?

    # Priority 2: Fallback to the formatted address, but cleaned up
    # Strip Plus Codes (e.g., 6WHX+JQ or 8CFV6WHX+JQ) if they appear at the start
    clean_fallback = fallback.to_s.gsub(/^[A-Z0-9]{4,8}\+[A-Z0-9]{2,}\s?/, '')

    # Take components, remove state/UF suffix (e.g., " - DF")
    parts = clean_fallback.split(',').map(&:strip).map { |p| p.gsub(/\s-\s[A-Z]{2}$/, '') }

    # Return first two distinct components (usually Neighborhood and City)
    parts.uniq.first(2).join(', ')
  end

  def street_alert_and_location_changed?
    street_alert? && location_changed? && (latitude.blank? || longitude.blank?)
  end

  def set_coordinates
    return unless user&.address

    self.latitude = user.address.latitude
    self.longitude = user.address.longitude
    self.location = user.address.anonymized_address
  end
end
