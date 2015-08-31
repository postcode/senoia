class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :plan_id
      t.text :email
      t.string :role

      t.timestamps null: false
    end
  end
end
