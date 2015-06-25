class AddNamePhoneToFirstAidStations < ActiveRecord::Migration
  def change
    add_column :first_aid_stations, :contact_name, :string
    add_column :first_aid_stations, :contact_phone, :string
  end
end
