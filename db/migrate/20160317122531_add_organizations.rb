class AddOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone_number
      t.integer :organization_type_id

      t.timestamps null: false
    end
  end
end
