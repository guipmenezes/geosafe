# frozen_string_literal: true

class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, alert_id)
    user = User.find_by(id: user_id)
    alert = Alert.find_by(id: alert_id)
    return unless user && alert && user.push_subscriptions.any?

    payload = build_payload(alert)

    user.push_subscriptions.find_each do |sub|
      send_notification_to_subscription(sub, payload)
    end
  end

  private

  def build_payload(alert)
    {
      title: 'Alerta de Perigo!',
      body: "Um incidente (#{alert.category_name}) foi reportado próximo a uma das suas Zonas de Interesse: #{alert.title}",
      icon: '/apple-touch-icon.png',
      url: '/'
    }.to_json
  end

  def send_notification_to_subscription(sub, payload)
    WebPush.payload_send(
      message: payload,
      endpoint: sub.endpoint,
      p256dh: sub.p256dh,
      auth: sub.auth,
      vapid: vapid_keys
    )
  rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription, WebPush::Unauthorized
    # Remove a inscrição do banco se ela tiver expirado ou sido revogada pelo usuário no navegador
    sub.destroy
  rescue StandardError => e
    Rails.logger.error "PushNotificationJob Error: #{e.message}"
  end

  def vapid_keys
    {
      subject: 'mailto:suporte@geosafe.com',
      public_key: Rails.application.credentials.vapid_public_key,
      private_key: Rails.application.credentials.vapid_private_key
    }
  end
end
