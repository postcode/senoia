# == Schema Information
#
# Table name: operation_periods
#
#  id                         :integer          not null, primary key
#  start_date                 :datetime
#  end_date                   :datetime
#  attendance                 :integer
#  plan_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  patients_treated_count     :integer
#  patients_transported_count :integer
#  start_time                 :datetime
#  end_time                   :datetime
#

class OperationPeriod < ActiveRecord::Base
  acts_as_commentable
  has_many :first_aid_stations
  has_many :mobile_teams
  has_many :transports
  has_many :dispatchs
  belongs_to :plan

  accepts_nested_attributes_for :first_aid_stations, :mobile_teams, :transports, :dispatchs, allow_destroy: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  
  include CustomDateTimeFormat
  use_custom_datetime_format_for :start_date, :end_date

  def to_s
    [
     start_date.strftime(DEFAULT_DATETIME_FORMAT),
     "to",
     end_date.strftime(DEFAULT_DATETIME_FORMAT)
    ].join(" ")
  end

  def formatted_start_date
    start_date.getutc.strftime("%m/%d/%Y") if start_date
  end

  def formatted_end_date
    end_date.getutc.strftime("%m/%d/%Y") if end_date
  end

  def formatted_start_time
    start_time.strftime("%I:%M %p") if start_date
  end

  def formatted_end_time
    end_time.strftime("%I:%M %p") if end_time
  end
  
end
