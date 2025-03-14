class AddColumnToAddressTable < ActiveRecord::Migration[7.1]
  def up
    add_column :addresses, :number, :integer
  end

  def down
    remove_column :addresses, :number
  end
end
