class CreateVenue < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name


      t.timestamps null: false
    end
  end
end
