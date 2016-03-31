class AddCrowdEstimateToOperationalPeriods < ActiveRecord::Migration
  def change
    add_column :operation_periods, :crowd_estimate, :string
  end
end
