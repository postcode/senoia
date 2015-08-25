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
  extend SimpleCalendar
  has_calendar attribute: :start_date
  acts_as_commentable
  has_many :first_aid_stations
  has_many :mobile_teams
  has_many :transports
  has_many :dispatchs
  belongs_to :plan

  accepts_nested_attributes_for :first_aid_stations, :mobile_teams, :transports, :dispatchs

  validates :start_date, presence: true
  validates :end_date, presence: true
  
  DEFAULT_DATETIME_FORMAT = "%m/%d/%Y %H:%M %p"
  
  def start_date=(new_start_date)
    if new_start_date =~ /[0-9]{2}\/[0-9]{2}\/[0-9]{4}/
      super(DateTime.strptime(new_start_date, DEFAULT_DATETIME_FORMAT))
    else
      super
    end
  end

  def end_date=(new_end_date)
    if new_end_date =~ /[0-9]{2}\/[0-9]{2}\/[0-9]{4}/
      super(DateTime.strptime(new_end_date, DEFAULT_DATETIME_FORMAT))
    else
      super
    end
  end
  
end
