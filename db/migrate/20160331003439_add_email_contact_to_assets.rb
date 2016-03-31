class AddEmailContactToAssets < ActiveRecord::Migration
  def change
    add_column :dispatches, :planning_contact_email, :string
    add_column :first_aid_stations, :planning_contact_email, :string
    add_column :mobile_teams, :planning_contact_email, :string
    add_column :transports, :planning_contact_email, :string
  end
end
