class AddUfToAlerts < ActiveRecord::Migration[7.1]
  def change
    add_column :alerts, :uf, :string
    add_index :alerts, [:uf, :created_at]
  end
end
