# == Schema Information
#
# Table name: operation_periods
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  end_date   :datetime
#  attendance :integer
#  plan_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OperationPeriod < ActiveRecord::Base
  acts_as_commentable
  has_many :first_aid_stations, through: :medical_assets
  has_many :mobile_teams, through: :medical_assets
  has_many :transports, through: :medical_assets
  has_many :dispatchs, through: :medical_assets
  belongs_to :plan

  accepts_nested_attributes_for :first_aid_stations, :mobile_teams, :transports, :dispatchs
end
