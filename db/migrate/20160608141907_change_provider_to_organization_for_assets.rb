class ChangeProviderToOrganizationForAssets < ActiveRecord::Migration
  def change
    rename_column :first_aid_stations, :provider_id, :organization_id
    rename_column :mobile_teams, :provider_id, :organization_id
    rename_column :dispatches, :provider_id, :organization_id
    rename_column :transports, :provider_id, :organization_id
  end
end
