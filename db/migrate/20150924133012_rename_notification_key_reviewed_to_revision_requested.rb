class RenameNotificationKeyReviewedToRevisionRequested < ActiveRecord::Migration
  def up
    execute "UPDATE notifications SET key='revision_requested' WHERE key='reviewed'"
  end

  def down
    execute "UPDATE notifications SET key='reviewed' WHERE key='revision_requested'"
  end
end
