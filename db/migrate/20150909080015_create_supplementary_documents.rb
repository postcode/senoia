class CreateSupplementaryDocuments < ActiveRecord::Migration
  def change
    create_table :supplementary_documents do |t|
      t.text :name
      t.text :description
      t.text :file
      t.integer :plan_id

      t.timestamps null: false
    end
  end
end
