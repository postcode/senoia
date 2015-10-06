class CreateTransportationRecords < ActiveRecord::Migration
  def change
    create_table :transportation_records do |t|
      t.belongs_to :post_event_treatment_report, index: true
      t.text :chief_complaint
      t.belongs_to :transport, index: true
      t.text :destination
      t.datetime :transported_at

      t.timestamps null: false
    end
  end
end
