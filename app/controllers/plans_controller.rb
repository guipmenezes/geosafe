# frozen_string_literal: true

class PlansController < ApplicationController
  def index
    @plans = Plan.all
  end
end
