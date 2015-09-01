class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :plan_id
      t.text :email
      t.string :role
      t.integer :invited_user_id

      t.timestamps null: false
    end
  end
end
