class ChangePermitterIdToOrganizationId < ActiveRecord::Migration
  def change
    rename_column :plans, :permitter_id, :organization_id
  end
end
