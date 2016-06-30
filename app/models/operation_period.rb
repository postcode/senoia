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
#  service_area               :text
#  crowd_estimate             :string
#  location                   :text
#

class OperationPeriod < ActiveRecord::Base
  extend SimpleCalendar
  acts_as_commentable
  has_many :first_aid_stations
  has_many :mobile_teams
  has_many :transports
  has_many :dispatchs
  belongs_to :plan

  accepts_nested_attributes_for :first_aid_stations, :mobile_teams, :transports, :dispatchs, allow_destroy: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :attendance, presence: true, numericality: { only_integer: true, greater_than: 0 }

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
    start_time.strftime("%H:%M") if start_time
  end

  def formatted_end_time
    end_time.strftime("%H:%M") if end_time
  end

  def start_date_time
    d = start_date.getutc
    t = start_time
    if d.present? && t.present?
      DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day, t.hour, t.min)
    elsif d.present?
      DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day)
    end
  end

  def end_date_time
    d = end_date.getutc
    t = end_time
    if d.present? && t.present?
      DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day, t.hour, t.min)
    end
  end

  def self.all_approved
    op = []
    Plan.with_approved_state.each do |p|
      op << p.operation_periods
    end
    op.flatten
  end

end
