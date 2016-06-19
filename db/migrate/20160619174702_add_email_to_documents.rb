class AddEmailToDocuments < ActiveRecord::Migration
  def change
    add_column :supplementary_documents, :email, :boolean, default: true
  end
end
