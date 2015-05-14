class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :phone_number
      t.text :address

      t.timestamps null: false
    end
  end
end
