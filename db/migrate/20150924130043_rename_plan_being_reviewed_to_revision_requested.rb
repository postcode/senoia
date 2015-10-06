class RenamePlanBeingReviewedToRevisionRequested < ActiveRecord::Migration
  def up
    execute "UPDATE plans SET workflow_state='revision_requested' WHERE workflow_state='being_reviewed'"
  end

  def down
    execute "UPDATE plans SET workflow_state='being_reviewed' WHERE workflow_state='revision_requested'"
  end
end
