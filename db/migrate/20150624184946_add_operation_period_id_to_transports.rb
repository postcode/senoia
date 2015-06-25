class AddOperationPeriodIdToTransports < ActiveRecord::Migration
  def change
    add_column :transports, :operation_period_id, :integer
  end
end
