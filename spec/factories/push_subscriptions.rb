# frozen_string_literal: true

FactoryBot.define do
  factory :push_subscription do
    user
    endpoint { "https://fcm.googleapis.com/fcm/send/fake-endpoint-#{SecureRandom.hex}" }
    p256dh { 'fake_p256dh_key' }
    auth { 'fake_auth_key' }
    user_agent { 'TestBrowser 1.0' }
  end
end
