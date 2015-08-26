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

  def start_date=(new_end_date)
    super parse_date_time_if_in_preferred_format(new_end_date)
  end

  def end_date=(new_end_date)
    super parse_date_time_if_in_preferred_format(new_end_date)
  end

  private

  def parse_date_time_if_in_preferred_format(date_time)
    if date_time =~ /[0-9]{2}\/[0-9]{2}\/[0-9]{4}/
      DateTime.strptime(date_time, DEFAULT_DATETIME_FORMAT)
    else
      date_time
    end
  end
  
end
