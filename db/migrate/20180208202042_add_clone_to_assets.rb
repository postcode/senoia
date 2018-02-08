class AddCloneToAssets < ActiveRecord::Migration
  def change
    add_column :dispatches, :clone, :boolean, default: false
    add_column :first_aid_stations, :clone, :boolean, default: false
    add_column :mobile_teams, :clone, :boolean, default: false
    add_column :transports, :clone, :boolean, default: false
  end
end
