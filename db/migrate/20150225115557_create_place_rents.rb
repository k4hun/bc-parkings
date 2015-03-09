class CreatePlaceRents < ActiveRecord::Migration
  def change
    create_table :place_rents do |t|
      t.integer :parking_id
      t.integer :car_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.decimal :price

      t.timestamps null: false
    end
    add_index :place_rents, :parking_id
    add_index :place_rents, :car_id
  end
end
