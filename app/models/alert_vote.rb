# frozen_string_literal: true

class AlertVote < ApplicationRecord
  belongs_to :user
  belongs_to :alert

  enum :vote_type, { relevant: 1, inappropriate: 2 }

  validates :user_id, uniqueness: { scope: :alert_id }
  validates :vote_type, presence: true

  after_save :update_alert_counters
  after_save :update_user_points, if: :relevant?
  after_destroy :update_alert_counters
  after_destroy :decrement_user_points, if: :relevant?

  private

  def update_alert_counters
    alert.update(
      relevant: alert.alert_votes.relevant.count,
      inappropriate: alert.alert_votes.inappropriate.count
    )
  end

  def update_user_points
    # The creator of the alert gains points when someone marks it as relevant
    alert.user.increment!(:geopoints, 10)
  end

  def decrement_user_points
    alert.user.decrement!(:geopoints, 10)
  end
end
