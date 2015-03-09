class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :registration_number
      t.string :model
      t.integer :owner_id

      t.timestamps null: false
    end
    add_index :cars, :owner_id
  end
end
