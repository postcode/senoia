class AddWeatherToPetr < ActiveRecord::Migration
  def change
    add_column :post_event_treatment_reports, :weather, :text
  end
end
