class AddWorkflowToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :workflow_state, :string
  end
end
