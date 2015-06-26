class AddAcceptanceFieldsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :event_contact, :text
    add_column :plans, :responsibility, :boolean
    add_column :plans, :cpr, :boolean
    add_column :plans, :communication, :boolean
    add_column :plans, :post_event_name, :string
    add_column :plans, :post_event_email, :string
    add_column :plans, :post_event_phone, :string
    add_column :plans, :creator_id, :integer
  end
end
