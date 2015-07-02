class AddContactToDispatch < ActiveRecord::Migration
  def change
    add_column :dispatches, :contact_name, :string
    add_column :dispatches, :contact_phone, :string
  end
end
