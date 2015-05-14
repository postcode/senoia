# == Schema Information
#
# Table name: plans
#
#  id            :integer          not null, primary key
#  name          :string
#  owner_id      :integer
#  start_date    :datetime
#  end_date      :datetime
#  attendance    :integer
#  alcohol       :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  event_type_id :integer
#  permitter_id  :integer
#

class Plan < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar attribute: :start_date
  belongs_to :owner, class_name: User
  belongs_to :event_type
  belongs_to :permitter

  has_many :operation_period

  accepts_nested_attributes_for :event_type, :operation_period

  include Workflow
  workflow do
    state :draft do
      event :submit, :transitions_to => :awaiting_review
    end
    state :awaiting_review do
      event :review, :transitions_to => :being_reviewed
    end
    state :being_reviewed do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end
end
