class CreateTransportsUser < ActiveRecord::Migration
  def change
    create_table :transports_users do |t|
      t.integer :transport_id
      t.integer :user_id
      t.boolean :contact
    end
  end
end
