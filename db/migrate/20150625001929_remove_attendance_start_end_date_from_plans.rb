class RemoveAttendanceStartEndDateFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :attendance
    remove_column :plans, :start_date
    remove_column :plans, :end_date
  end
end
