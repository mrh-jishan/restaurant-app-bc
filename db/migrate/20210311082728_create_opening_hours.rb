class CreateOpeningHours < ActiveRecord::Migration[6.1]
  def change
    create_table :opening_hours do |t|
      t.references :restaurant
      t.integer :day_of_week
      t.time :closes
      t.time :opens

      t.timestamps
    end
  end
end
