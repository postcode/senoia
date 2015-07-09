class AddRoleToPlanUsers < ActiveRecord::Migration
  def change
    add_column :plan_users, :role, :string
  end
end
