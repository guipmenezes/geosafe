# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @notifications = Current.user.notifications.ordered.limit(20)
  end

  def update
    @notification = Current.user.notifications.find(params[:id])
    @notification.update(read_at: Time.current)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path }
    end
  end

  def bulk_read
    Current.user.notifications.unread.update_all(read_at: Time.current)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('notification-bell', partial: 'notifications/bell', locals: { user: Current.user })
      end
      format.html { redirect_back fallback_location: notifications_path }
    end
  end
end
