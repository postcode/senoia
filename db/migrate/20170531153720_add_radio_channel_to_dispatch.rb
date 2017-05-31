class AddRadioChannelToDispatch < ActiveRecord::Migration
  def change
    add_column :dispatches, :radio_channel, :string
  end
end
