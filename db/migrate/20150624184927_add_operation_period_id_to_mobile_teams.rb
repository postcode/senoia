class AddOperationPeriodIdToMobileTeams < ActiveRecord::Migration
  def change
    add_column :mobile_teams, :operation_period_id, :integer
  end
end
