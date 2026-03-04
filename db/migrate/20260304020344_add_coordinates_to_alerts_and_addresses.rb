class AddCoordinatesToAlertsAndAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :alerts, :latitude, :float
    add_column :alerts, :longitude, :float
    add_column :addresses, :latitude, :float
    add_column :addresses, :longitude, :float
  end
end
