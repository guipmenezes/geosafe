class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
      t.integer :name
      t.integer :price_cents
      t.string :description

      t.timestamps
    end
  end
end
