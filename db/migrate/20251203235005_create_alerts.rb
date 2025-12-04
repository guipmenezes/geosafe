# frozen_string_literal: true

class CreateAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :alerts do |t|
      t.integer :type
      t.integer :alert
      t.string :location
      t.boolean :resident
      t.integer :relevant
      t.integer :inappropriate
      t.integer :user_id

      t.timestamps
    end
  end
end
