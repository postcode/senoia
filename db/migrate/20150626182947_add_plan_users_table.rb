class AddPlanUsersTable < ActiveRecord::Migration
  def change
    create_table :plan_users do |t|
      t.integer :user_id
      t.integer :plan_id
    end
  end
end
