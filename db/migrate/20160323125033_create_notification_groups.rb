class CreateNotificationGroups < ActiveRecord::Migration
  def change
    create_table :notification_groups do |t|
      t.string :name
      t.text :description
      t.string :notification_type

      t.timestamps null: false
    end
  end
end
