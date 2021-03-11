class CreateFavouriteItems < ActiveRecord::Migration[6.1]
  def change
    create_table :favourite_items do |t|
      t.references :restaurant
      t.references :favourite
      t.timestamps
    end
  end
end
