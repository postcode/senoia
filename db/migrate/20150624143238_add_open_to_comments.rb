class AddOpenToComments < ActiveRecord::Migration
  def change
    add_column :comments, :open, :boolean, default: true
  end
end
