# frozen_string_literal: true

class HomeController < ApplicationController
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  def index
    @options = %w[20km 50km 100km 200km]
    @alert = Alert.new

    @ufs = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO]
    @current_uf = params[:uf].presence || Current.user&.address&.uf || 'SP'

    @alerts = fetch_alerts

    respond_to do |format|
      format.html do
        @alerts_json = @alerts.map(&:as_json_for_map).to_json
        mark_notifications_as_read if params[:alert_id].present?
      end
      format.json do
        render json: @alerts.map { |a|
          a.as_json_for_map.merge(
            html: render_to_string(AlertCard::AlertCardComponent.new(alert: a), layout: false)
          )
        }
      end
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  private

  def fetch_alerts
    alerts = Alert.includes(:user, :alert_votes).where('created_at >= ?', 30.days.ago)

    if params[:bounds].present?
      bounds = params[:bounds].split(',')
      alerts = alerts.within_bounding_box(bounds)
    else
      alerts = alerts.where(uf: @current_uf) unless @current_uf == 'BR'
    end

    alerts.order(created_at: :desc).limit(1000)
  end

  def mark_notifications_as_read
    return unless Current.user

    Current.user.notifications.unread.where(alert_id: params[:alert_id]).update_all(read_at: Time.current)
  end
end
