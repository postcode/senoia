class CreateMobileTeams < ActiveRecord::Migration
  def change
    create_table :mobile_teams do |t|
      t.string :level
      t.string :type
      t.integer :aed
      t.integer :provider_id
      t.string :name
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
