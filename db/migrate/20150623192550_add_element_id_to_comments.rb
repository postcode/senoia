class AddElementIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :element_id, :string 
  end
end
