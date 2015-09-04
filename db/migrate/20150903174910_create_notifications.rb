class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :subject_id
      t.string :subject_type
      t.text :key
      t.integer :owner_id
      t.boolean :read, null: false, default: false

      t.timestamps null: false
    end
  end
end
