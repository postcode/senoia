class CreatePlansTable < ActiveRecord::Migration
  def change
    create_table :plans_tables do |t|
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
