# frozen_string_literal: true

class ArchiveOldAlertsJob < ApplicationJob
  queue_as :default

  def perform
    # Find alerts older than 30 days
    old_alerts = Alert.where('created_at < ?', 30.days.ago)

    # Process them in batches to avoid eating up memory
    old_alerts.find_in_batches(batch_size: 500) do |alerts_batch|
      ArchivedAlert.transaction do
        alerts_attributes = alerts_batch.map do |alert|
          alert.attributes.except('id')
        end

        # Bulk insert into archived_alerts
        ArchivedAlert.insert_all(alerts_attributes) if alerts_attributes.any?

        # Delete the archived alerts from the main table
        # We use delete_all to avoid instantiating callbacks for performance,
        # but if we need to clean up dependencies (like alert_votes), we should use destroy_all or do it manually.
        # Since alert_votes has dependent: :destroy, destroy_all is safer.
        Alert.where(id: alerts_batch.map(&:id)).destroy_all
      end
    end
  end
end
