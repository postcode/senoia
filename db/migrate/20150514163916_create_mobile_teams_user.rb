class CreateMobileTeamsUser < ActiveRecord::Migration
  def change
    create_table :mobile_teams_users do |t|
      t.integer :mobile_team_id
      t.integer :user_id
      t.boolean :contact
    end
  end
end
