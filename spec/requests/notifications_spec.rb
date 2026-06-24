# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:user) { create(:user) }
  let(:alert) { create(:alert, user: user) }
  let!(:notification) { Notification.create!(user: user, alert: alert) }

  before do
    sign_in user
  end

  describe 'GET /notifications' do
    it 'renders a successful response' do
      get notifications_path
      expect(response).to be_successful
      expect(response.body).to include(notification.alert.title)
    end
  end

  describe 'PATCH /notifications/:id' do
    it 'marks the notification as read' do
      expect do
        patch notification_path(notification), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
      end.to change { notification.reload.read_at }.from(nil)
    end

    it 'returns a turbo stream template' do
      patch notification_path(notification), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/vnd.turbo-stream.html')
    end

    it 'redirects to notifications_path for HTML requests' do
      patch notification_path(notification)
      expect(response).to redirect_to(notifications_path)
    end
  end

  describe 'POST /notifications/bulk_read' do
    before do
      # Clear existing read notifications to keep count simple
      user.notifications.destroy_all
      3.times { Notification.create!(user: user, alert: alert) }
    end

    it 'marks all unread notifications as read' do
      expect do
        post bulk_read_notifications_path
      end.to change { user.notifications.unread.count }.from(3).to(0)
    end

    it 'redirects back or to notifications_path' do
      post bulk_read_notifications_path
      expect(response).to redirect_to(notifications_path)
    end
  end
end
