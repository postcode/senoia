class AddPlanUsersTable < ActiveRecord::Migration
  def change
    drop_table :plans_users
    create_table :plan_users do |t|
      t.integer :user_id
      t.integer :plan_id
    end
  end
end
