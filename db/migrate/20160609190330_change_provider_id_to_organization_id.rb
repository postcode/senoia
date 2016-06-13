class ChangeProviderIdToOrganizationId < ActiveRecord::Migration
  def change
    rename_column :provider_confirmations, :provider_id, :organization_id
  end
end
