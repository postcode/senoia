class AddOperationPeriodIdToDispatchs < ActiveRecord::Migration
  def change
    add_column :dispatches, :operation_period_id, :integer
  end
end
