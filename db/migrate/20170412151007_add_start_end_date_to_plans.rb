class AddStartEndDateToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :start_datetime, :datetime
    add_column :plans, :end_datetime, :datetime
  end
end
