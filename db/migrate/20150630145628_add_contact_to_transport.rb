class AddContactToTransport < ActiveRecord::Migration
  def change
    add_column :transports, :contact_name, :string
    add_column :transports, :contact_phone, :string
  end
end
