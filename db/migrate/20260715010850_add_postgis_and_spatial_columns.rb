# frozen_string_literal: true

class AddPostgisAndSpatialColumns < ActiveRecord::Migration[7.1]
  def up
    enable_extension 'postgis' unless extension_enabled?('postgis')

    add_column :alerts, :lonlat, :st_point, geographic: true, srid: 4326
    add_column :addresses, :lonlat, :st_point, geographic: true, srid: 4326

    add_index :alerts, :lonlat, using: :gist
    add_index :addresses, :lonlat, using: :gist

    # Backfill existing data
    execute <<-SQL
      UPDATE alerts SET lonlat = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
      WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
    SQL

    execute <<-SQL
      UPDATE addresses SET lonlat = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
      WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
    SQL
  end

  def down
    remove_index :addresses, :lonlat
    remove_index :alerts, :lonlat

    remove_column :addresses, :lonlat
    remove_column :alerts, :lonlat

    disable_extension 'postgis' if extension_enabled?('postgis')
  end
end
