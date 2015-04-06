class AddPlans < ActiveRecord::Migration
  def change
    drop_table :plans_tables

    create_table :plans do |t|
      t.string :name
      t.integer :owner_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :attendance
      t.integer :event_type
      t.boolean :alcohol
    end
  end
end
