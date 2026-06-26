class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, alert_id)
    user = User.find_by(id: user_id)
    alert = Alert.find_by(id: alert_id)
    return unless user && alert && user.push_subscriptions.any?

    payload = {
      title: "Alerta de Perigo!",
      body: "Um incidente (#{alert.category_name}) foi reportado próximo a uma das suas Zonas de Interesse: #{alert.title}",
      icon: "/apple-touch-icon.png",
      url: "/"
    }.to_json

    user.push_subscriptions.find_each do |sub|
      begin
        WebPush.payload_send(
          message: payload,
          endpoint: sub.endpoint,
          p256dh: sub.p256dh,
          auth: sub.auth,
          vapid: {
            subject: "mailto:suporte@geosafe.com",
            public_key: ENV['VAPID_PUBLIC_KEY'],
            private_key: ENV['VAPID_PRIVATE_KEY']
          }
        )
      rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription, WebPush::Unauthorized
        # Remove a inscrição do banco se ela tiver expirado ou sido revogada pelo usuário no navegador
        sub.destroy
      rescue StandardError => e
        Rails.logger.error "PushNotificationJob Error: #{e.message}"
      end
    end
  end
end
