class AddStaffResponsibilityToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :staff_responsibility, :boolean
  end
end
