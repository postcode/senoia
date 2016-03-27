class CreateAssetsCommunications < ActiveRecord::Migration
  def change
    create_table :asset_communications do |t|
      t.integer :asset_id
      t.integer :communication_id
    end
  end
end
