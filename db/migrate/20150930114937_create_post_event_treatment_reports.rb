class CreatePostEventTreatmentReports < ActiveRecord::Migration
  def change
    create_table :post_event_treatment_reports do |t|
      t.belongs_to :plan
      t.belongs_to :creator
      t.integer :actual_crowd_size
      t.text :resource_differences
      t.string :medical_resource_sufficiency
      t.text :medical_resource_sufficiency_explanation
      t.text :other_comments
      t.boolean :submitted

      t.timestamps null: false
    end
    add_index :post_event_treatment_reports, :plan_id
  end
end
