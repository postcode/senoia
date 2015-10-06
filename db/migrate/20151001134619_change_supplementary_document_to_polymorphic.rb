class ChangeSupplementaryDocumentToPolymorphic < ActiveRecord::Migration
  def change
    rename_column :supplementary_documents, :plan_id, :parent_id
    add_column :supplementary_documents, :parent_type, :string
  end
end
