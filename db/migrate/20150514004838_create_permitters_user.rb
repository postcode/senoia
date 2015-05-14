class CreatePermittersUser < ActiveRecord::Migration
  def change
    create_table :permitters_users do |t|
      t.integer :permitter_id
      t.integer :user_id
      t.boolean :contact
    end
  end
end
