# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @options = %w[20km 50km 100km 200km]
    @alert = Alert.new
  end
end
