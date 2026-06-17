class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :alert

  scope :unread, -> { where(read_at: nil) }
  scope :ordered, -> { order(created_at: :desc) }

  validates :user_id, :alert_id, presence: true

  after_create_commit :broadcast_notification
  after_update_commit :broadcast_notification

  private

  def broadcast_notification
    broadcast_replace_to [user, :notifications],
                      target: "notification-bell",
                      partial: "notifications/bell",
                      locals: { user: user }
  end
end
