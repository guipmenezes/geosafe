# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @options = ["20km", "50km", "100km", "200km"]
  end
end

