class OperationPeriod < ActiveRecord::Base
  has_many :first_aid_stations, through: :medical_assets
  belongs_to :plan
end
