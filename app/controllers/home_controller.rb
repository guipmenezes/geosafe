# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @options = %w[20km 50km 100km 200km]
    @alert = Alert.new
    @alerts = Alert.all.order(created_at: :desc)
    @alerts_json = @alerts.map(&:as_json_for_map).to_json
  end
end
