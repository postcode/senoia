class AddPatientCountsToOperationPeriod < ActiveRecord::Migration
  def change
    add_column :operation_periods, :patients_treated_count, :integer
    add_column :operation_periods, :patients_transported_count, :integer
  end
end
