# frozen_string_literal: true

Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # geocoding service timeout (secs)
  lookup: :google,            # name of geocoding service (symbol)
  api_key: Rails.application.credentials.maps_api_key, # API key for geocoding service
  units: :km # :km for kilometers or :mi for miles

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # distances: :linear          # :spherical or :linear
)
