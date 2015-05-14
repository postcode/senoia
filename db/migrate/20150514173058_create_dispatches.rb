class CreateDispatches < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.string :name
      t.string :level
      t.integer :provider_id

      t.timestamps null: false
    end
  end
end
