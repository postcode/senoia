class AddEmailToPermitter < ActiveRecord::Migration
  def change
    add_column :permitters, :email, :text
  end
end
