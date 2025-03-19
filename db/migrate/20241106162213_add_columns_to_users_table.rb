class AddColumnsToUsersTable < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :full_name, :string
    add_column :users, :username, :string
    add_column :users, :geopoints, :integer
  end

  def down
    remove_column :users, :full_name
    remove_column :users, :username
    remove_column :users, :geopoints
  end
end
