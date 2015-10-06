class RenameNotificationKeyAcceptedToApproved < ActiveRecord::Migration
  def up
    execute "UPDATE notifications SET key='approved' WHERE key='accepted'"
  end

  def down
    execute "UPDATE notifications SET key='accepted' WHERE key='approved'"
  end
end
