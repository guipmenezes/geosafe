# frozen_string_literal: true

class AddCategoryToAlerts < ActiveRecord::Migration[7.1]
  def change
    add_column :alerts, :category, :integer
    add_index :alerts, :category
  end
end
