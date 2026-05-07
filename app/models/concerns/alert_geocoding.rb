# frozen_string_literal: true

module AlertGeocoding
  extend ActiveSupport::Concern

  private

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
    locality_parts = [data[:neighborhood], data[:city]].compact.uniq
    return locality_parts.join(', ') if locality_parts.any?

    clean_fallback = fallback.to_s.gsub(/^[A-Z0-9]{4,8}\+[A-Z0-9]{2,}\s?/, '')
    parts = clean_fallback.split(',').map(&:strip).map { |p| p.gsub(/\s-\s[A-Z]{2}$/, '') }
    parts.uniq.first(2).join(', ')
  end
end
