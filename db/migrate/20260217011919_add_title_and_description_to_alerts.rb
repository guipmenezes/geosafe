# frozen_string_literal: true

class AddTitleAndDescriptionToAlerts < ActiveRecord::Migration[7.1]
  def change
    add_column :alerts, :title, :string
    add_column :alerts, :description, :text
  end
end
