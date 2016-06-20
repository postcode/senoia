class AddApprovalDateToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :approval_date, :datetime
  end
end
