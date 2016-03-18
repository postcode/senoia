class CreatePlanVenues < ActiveRecord::Migration
  def change
    create_table :plan_venues do |t|
      t.integer :plan_id
      t.integer :venue_id
    end
  end
end
