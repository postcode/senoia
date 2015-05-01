class AddTimestampsToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :created_at, :datetime
    add_column :plans, :updated_at, :datetime
  end
end
