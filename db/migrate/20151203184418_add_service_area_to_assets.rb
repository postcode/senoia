class AddServiceAreaToAssets < ActiveRecord::Migration
  def change
    add_column :first_aid_stations, :service_area, :text
    add_column :transports, :service_area, :text
    add_column :mobile_teams, :service_area, :text
    add_column :dispatches, :service_area, :text
  end
end
