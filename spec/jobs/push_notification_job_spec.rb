# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PushNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:alert) { create(:alert, category: Alert::SECURITY, title: 'Roubo reportado') }
  let!(:subscription) { create(:push_subscription, user: user) }

  describe '#perform' do
    it 'sends a push notification via WebPush' do
      expect(WebPush).to receive(:payload_send).with(
        hash_including(
          endpoint: subscription.endpoint,
          p256dh: subscription.p256dh,
          auth: subscription.auth
        )
      )

      PushNotificationJob.new.perform(user.id, alert.id)
    end

    it 'destroys subscription if WebPush raises ExpiredSubscription' do
      allow(WebPush).to receive(:payload_send).and_raise(WebPush::ExpiredSubscription.new(double(body: 'error'), nil))

      expect do
        PushNotificationJob.new.perform(user.id, alert.id)
      end.to change(PushSubscription, :count).by(-1)
    end
  end
end
