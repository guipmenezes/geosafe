# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @options = %w[20km 50km 100km 200km]
    @alert = Alert.new
    @alerts = Alert.includes(:user, :alert_votes)
                   .where('created_at >= ?', 30.days.ago)
                   .order(created_at: :desc)
                   .limit(1000)
    @alerts_json = @alerts.map(&:as_json_for_map).to_json

    mark_notifications_as_read if params[:alert_id].present?
  end

  private

  def mark_notifications_as_read
    return unless Current.user

    Current.user.notifications.unread.where(alert_id: params[:alert_id]).update_all(read_at: Time.current)
  end
end
