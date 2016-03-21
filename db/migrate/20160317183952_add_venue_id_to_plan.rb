class AddVenueIdToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :venue_id, :integer

  end
end
