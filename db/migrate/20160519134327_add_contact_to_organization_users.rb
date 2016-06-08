class AddContactToOrganizationUsers < ActiveRecord::Migration
  def change
    add_column :organization_users, :contact, :boolean, default: true
  end
end
