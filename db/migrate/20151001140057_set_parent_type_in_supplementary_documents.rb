class SetParentTypeInSupplementaryDocuments < ActiveRecord::Migration
  def up
    execute("UPDATE supplementary_documents SET parent_type='Plan'")
  end
  def down
    execute("UPDATE supplementary_documents SET parent_type=NULL")
  end
end
