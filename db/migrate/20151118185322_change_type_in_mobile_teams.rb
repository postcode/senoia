class ChangeTypeInMobileTeams < ActiveRecord::Migration
  def change
    remove_column :mobile_teams, :type
    add_column :mobile_teams, :mobile_team_type, :string
  end
end
