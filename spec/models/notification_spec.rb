# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:alert) { create(:alert, user: user) }

  describe 'validations' do
    it 'is valid with a user and an alert' do
      notification = Notification.new(user: user, alert: alert)
      expect(notification).to be_valid
    end

    it 'is invalid without a user' do
      notification = Notification.new(alert: alert)
      expect(notification).not_to be_valid
    end

    it 'is invalid without an alert' do
      notification = Notification.new(user: user)
      expect(notification).not_to be_valid
    end
  end

  describe 'scopes' do
    it 'returns unread notifications' do
      unread_notification = Notification.create!(user: user, alert: alert, read_at: nil)
      read_notification = Notification.create!(user: user, alert: alert, read_at: Time.current)

      expect(Notification.unread).to include(unread_notification)
      expect(Notification.unread).not_to include(read_notification)
    end
  end

  describe '#broadcast_notification' do
    it 'broadcasts replacement of notification-bell and append to flash when unread' do
      notification = Notification.create!(user: user, alert: alert, read_at: nil)

      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).with(
        [user, :notifications],
        target: 'notification-bell',
        partial: 'notifications/bell',
        locals: { user: user, notification: notification }
      )
      expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
        [user, :notifications],
        target: 'flash',
        partial: 'notifications/toast',
        locals: { notification: notification }
      )

      notification.send(:broadcast_notification)
    end

    it 'broadcasts replacement of notification-bell but no flash toast when read' do
      notification = Notification.create!(user: user, alert: alert, read_at: Time.current)

      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).with(
        [user, :notifications],
        target: 'notification-bell',
        partial: 'notifications/bell',
        locals: { user: user, notification: notification }
      )
      expect(Turbo::StreamsChannel).not_to receive(:broadcast_append_to)

      notification.send(:broadcast_notification)
    end
  end
end
