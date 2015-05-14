class OperationPeriod < ActiveRecord::Base
  has_many :first_aid_stations, through: :medical_assets
  belongs_to :plan

  accepts_nested_attributes_for :first_aid_stations
end
