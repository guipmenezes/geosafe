class InterestZonesController < ApplicationController
  def index
    @addresses = Current.user.addresses.order(created_at: :asc)
  end
end
