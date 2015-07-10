class AddLocationToModels < ActiveRecord::Migration
  def change
    add_column :first_aid_stations, :location, :text
    add_column :transports, :location, :text
    add_column :mobile_teams, :location, :text
    add_column :dispatches, :location, :text
  end
end
