class CreateAlertVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :alert_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :alert, null: false, foreign_key: true
      t.integer :vote_type

      t.timestamps
    end
  end
end
