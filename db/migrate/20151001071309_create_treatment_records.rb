class CreateTreatmentRecords < ActiveRecord::Migration
  def change
    create_table :treatment_records do |t|
      t.belongs_to :post_event_treatment_report
      t.text :problem_description
      t.integer :persons_count
      t.text :treatment
      t.text :outcome

      t.timestamps null: false
    end
    add_index :treatment_records, :post_event_treatment_report_id
  end
end
