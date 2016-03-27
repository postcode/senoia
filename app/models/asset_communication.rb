# == Schema Information
#
# Table name: asset_communications
#
#  id                   :integer          not null, primary key
#  asset_id             :integer
#  communication_id     :integer
#  description          :text
#  dispatch_id          :integer
#  first_aid_station_id :integer
#  mobile_team_id       :integer
#  transport_id         :integer
#

class AssetCommunication < ActiveRecord::Base
  belongs_to :dispatch
  belongs_to :first_aid_station
  belongs_to :mobile_team
  belongs_to :transport
  belongs_to :communication
end
