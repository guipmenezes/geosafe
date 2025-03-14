class CreatePlanSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :plan_subscriptions do |t|
      t.integer :user_id
      t.integer :plan_id
      t.date :duration

      t.timestamps
    end
  end
end
