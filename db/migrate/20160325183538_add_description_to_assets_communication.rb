class AddDescriptionToAssetsCommunication < ActiveRecord::Migration
  def change
    add_column :asset_communications, :description, :text
  end
end
