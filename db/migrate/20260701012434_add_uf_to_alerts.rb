# frozen_string_literal: true

class AddUfToAlerts < ActiveRecord::Migration[7.1]
  def change
    add_column :alerts, :uf, :string
    add_index :alerts, %i[uf created_at]
  end
end
