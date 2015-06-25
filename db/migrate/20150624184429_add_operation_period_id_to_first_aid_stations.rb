class AddOperationPeriodIdToFirstAidStations < ActiveRecord::Migration
  def change
    add_column :first_aid_stations, :operation_period_id, :integer
  end
end
