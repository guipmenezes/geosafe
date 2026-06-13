# frozen_string_literal: true

class AddLabelToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :label, :string
  end
end
