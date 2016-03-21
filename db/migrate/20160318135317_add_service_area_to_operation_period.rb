class AddServiceAreaToOperationPeriod < ActiveRecord::Migration
  def change
    add_column :operation_periods, :service_area, :text
  end
end
