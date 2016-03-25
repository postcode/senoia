class AddCommPhoneToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :communication_phone, :string
  end
end
