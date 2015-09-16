class CreateProviderConfirmations < ActiveRecord::Migration
  def change
    create_table :provider_confirmations do |t|
      t.belongs_to :provider
      t.integer :medical_asset_id
      t.string :medical_asset_type
      t.string :workflow_state

      t.timestamps null: false
    end
  end
end
