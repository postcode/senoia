class CreateTransports < ActiveRecord::Migration
  def change
    create_table :transports do |t|
      t.string :name
      t.string :level
      t.integer :provider_id
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
