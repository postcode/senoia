class CreateNotificationGroupMemberships < ActiveRecord::Migration
  def change
    create_table :notification_group_memberships do |t|
      t.belongs_to :notification_group, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :notification_group_memberships, [ :notification_group_id, :user_id ], unique: true, name: "index_notification_group_memberships_on_ng_id_and_user_id"
  end
end
