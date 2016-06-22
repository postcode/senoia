class AddLocationToOperationPeriod < ActiveRecord::Migration
  def change
    add_column :operation_periods, :location, :text
  end
end
