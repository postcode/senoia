class AddStartEndTimeToOperationalPeriod < ActiveRecord::Migration
  def change
    add_column :operation_periods, :start_time, :datetime
    add_column :operation_periods, :end_time, :datetime
  end
end
