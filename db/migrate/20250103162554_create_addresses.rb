class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :cep
      t.string :uf
      t.string :address
      t.string :complement
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
