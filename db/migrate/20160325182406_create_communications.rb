class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
      t.string :name


      t.timestamps null: false
    end
  end
end
