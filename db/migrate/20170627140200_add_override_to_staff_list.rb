class AddOverrideToStaffList < ActiveRecord::Migration
  def change
    add_column :supplementary_documents, :override, :boolean, default: false
  end
end
