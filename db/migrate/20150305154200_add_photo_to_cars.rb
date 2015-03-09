class AddPhotoToCars < ActiveRecord::Migration
  def change
    add_column :cars, :image_uid, :string
  end
end
