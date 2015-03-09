class AddIdentifierToPlaceRents < ActiveRecord::Migration
  def change
    add_column :place_rents, :identifier, :string
  end
end
