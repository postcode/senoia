class CreateCommunicationPlan < ActiveRecord::Migration
  def change
    create_table :communication_plans do |t|
      t.string :event_coordinator_name
      t.string :event_coordinator_phone
      t.string :event_coordinator_email
      t.string :event_coordinator_organization
      t.string :event_supervisor_name
      t.string :event_supervisor_phone
      t.string :event_supervisor_email
      t.string :dispatch_supervisor_name
      t.string :dispatch_supervisor_phone
      t.string :dispatch_supervisor_email
      t.string :dispatch_supervisor_organization
      t.string :medical_group_supervisor_name
      t.string :medical_group_supervisor_phone
      t.string :medical_group_supervisor_email
      t.string :medical_group_supervisor_organization
      t.string :triage_supervisor_name
      t.string :triage_supervisor_phone
      t.string :triage_supervisor_email
      t.string :triage_supervisor_organization
      t.string :transport_supervisor_name
      t.string :transport_supervisor_email
      t.string :transport_supervisor_phone
      t.string :transport_supervisor_organization
      t.string :non_transport_supervisor_name
      t.string :non_transport_supervisor_email
      t.string :non_transport_supervisor_phone
      t.string :non_transport_supervisor_organization
      t.integer :plan_id

      t.timestamps null: false

    end
  end
end
