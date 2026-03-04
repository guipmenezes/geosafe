# frozen_string_literal: true

class AddUniqueIndexToAlertVotes < ActiveRecord::Migration[7.1]
  def change
    add_index :alert_votes, %i[user_id alert_id], unique: true
  end
end
