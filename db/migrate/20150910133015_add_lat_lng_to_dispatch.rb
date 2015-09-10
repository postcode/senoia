class AddLatLngToDispatch < ActiveRecord::Migration
  def change
    add_column :dispatches, :lat, :decimal, precision: 10, scale: 6
    add_column :dispatches, :lng, :decimal, precision: 10, scale: 6
  end
end
