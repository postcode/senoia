class CreatePermitters < ActiveRecord::Migration
  def change
    create_table :permitters do |t|
      t.string :name
      t.string :phone_number
      t.text :address

      t.timestamps null: false
    end
  end
end
