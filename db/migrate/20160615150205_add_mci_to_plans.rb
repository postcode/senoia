class AddMciToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :mci, :boolean, default: false
  end
end
