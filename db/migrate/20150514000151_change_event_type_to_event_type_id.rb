class ChangeEventTypeToEventTypeId < ActiveRecord::Migration
  def change
    remove_column :plans, :event_type
    add_column :plans, :event_type_id, :integer
  end
end
