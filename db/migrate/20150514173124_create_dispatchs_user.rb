class CreateDispatchsUser < ActiveRecord::Migration
  def change
    create_table :dispatchs_users do |t|
      t.integer :dispatch_id
      t.integer :user_id
      t.boolean :contact
    end
  end
end
