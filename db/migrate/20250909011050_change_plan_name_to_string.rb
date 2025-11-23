# frozen_string_literal: true

class ChangePlanNameToString < ActiveRecord::Migration[7.1]
  def change
    change_column :plans, :name, :string
  end
end
