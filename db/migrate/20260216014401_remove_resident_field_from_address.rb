# frozen_string_literal: true

class RemoveResidentFieldFromAddress < ActiveRecord::Migration[7.1]
  def change
    remove_column :alerts, :resident
  end
end
