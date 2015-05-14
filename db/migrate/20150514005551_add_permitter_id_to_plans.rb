class AddPermitterIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :permitter_id, :integer
  end
end
