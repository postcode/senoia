class RenamePlanAwaitingReviewToUnderReview < ActiveRecord::Migration
  def up
    execute "UPDATE plans SET workflow_state='under_review' WHERE workflow_state='awaiting_review'"
  end

  def down
    execute "UPDATE plans SET workflow_state='awaiting_review' WHERE workflow_state='under_review'"
  end
end
