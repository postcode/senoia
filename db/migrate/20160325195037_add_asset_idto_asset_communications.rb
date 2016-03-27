class AddAssetIdtoAssetCommunications < ActiveRecord::Migration
  def change
    add_column :asset_communications, :dispatch_id, :integer
    add_column :asset_communications, :first_aid_station_id, :integer
    add_column :asset_communications, :mobile_team_id, :integer
    add_column :asset_communications, :transport_id, :integer
  end
end
