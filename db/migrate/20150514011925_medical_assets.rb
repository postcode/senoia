class MedicalAssets < ActiveRecord::Migration
  def change
    create_table :medical_assets do |t|
      t.integer :asset_id
      t.integer :operational_period_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
