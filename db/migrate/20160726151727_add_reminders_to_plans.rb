class AddRemindersToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :staff_responsibility_reminder_1wk, :boolean
    add_column :plans, :staff_responsibility_reminder_2wk, :boolean
  end
end
