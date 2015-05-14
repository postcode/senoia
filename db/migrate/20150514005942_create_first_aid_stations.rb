class CreateFirstAidStations < ActiveRecord::Migration
  def change
    create_table :first_aid_stations do |t|
      t.string :name
      t.integer :md
      t.integer :rn
      t.integer :emt
      t.integer :aed
      t.string :level
      t.integer :provider_id
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
