class RenamePlanAcceptedToApproved < ActiveRecord::Migration
  def up
    execute "UPDATE plans SET workflow_state='approved' WHERE workflow_state='accepted'"
  end

  def down
    execute "UPDATE plans SET workflow_state='accepted' WHERE workflow_state='approved'"
  end
end
