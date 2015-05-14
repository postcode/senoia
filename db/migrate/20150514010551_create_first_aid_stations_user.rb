class CreateFirstAidStationsUser < ActiveRecord::Migration
  def change
    create_table :first_aid_stations_users do |t|
      t.integer :first_aid_staion_id
      t.integer :user_id
      t.boolean :contact
    end
  end
end
