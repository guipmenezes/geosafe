# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
class CreateArchivedAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table 'archived_alerts', force: :cascade do |t|
      t.integer 'alert_type'
      t.integer 'alert'
      t.string 'location'
      t.integer 'relevant'
      t.integer 'inappropriate'
      t.integer 'user_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'title'
      t.text 'description'
      t.float 'latitude'
      t.float 'longitude'
      t.integer 'category'
      t.string 'uf'
      t.geography 'lonlat', limit: { srid: 4326, type: 'st_point', geographic: true }
      t.index ['category'], name: 'index_archived_alerts_on_category'
      t.index ['lonlat'], name: 'index_archived_alerts_on_lonlat', using: :gist
      t.index %w[uf created_at], name: 'index_archived_alerts_on_uf_and_created_at'
    end
  end
end
# rubocop:enable Metrics/AbcSize
