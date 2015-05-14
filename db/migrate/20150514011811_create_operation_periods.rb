class CreateOperationPeriods < ActiveRecord::Migration
  def change
    create_table :operation_periods do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :attendance
      t.integer :plan_id

      t.timestamps null: false
    end
  end
end
