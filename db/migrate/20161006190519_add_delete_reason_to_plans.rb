class AddDeleteReasonToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :deleted_reason, :text
  end
end
