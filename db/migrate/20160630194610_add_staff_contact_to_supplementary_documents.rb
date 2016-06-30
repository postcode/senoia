class AddStaffContactToSupplementaryDocuments < ActiveRecord::Migration
  def change
    add_column :supplementary_documents, :staff_contact, :boolean, default: false
  end
end
