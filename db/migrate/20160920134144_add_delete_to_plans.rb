class AddDeleteToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :deleted, :boolean, default: false
  end
end
