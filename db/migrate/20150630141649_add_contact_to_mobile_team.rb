class AddContactToMobileTeam < ActiveRecord::Migration
  def change
    add_column :mobile_teams, :contact_name, :string
    add_column :mobile_teams, :contact_phone, :string
  end
end
