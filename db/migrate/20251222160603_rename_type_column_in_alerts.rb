# frozen_string_literal: true

class RenameTypeColumnInAlerts < ActiveRecord::Migration[7.1]
  def change
    rename_column :alerts, :type, :alert_type
  end
end