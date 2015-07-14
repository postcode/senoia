# == Schema Information
#
# Table name: plans
#
#  id               :integer          not null, primary key
#  name             :string
#  owner_id         :integer
#  alcohol          :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  event_type_id    :integer
#  permitter_id     :integer
#  workflow_state   :string
#  event_contact    :text
#  responsibility   :boolean
#  cpr              :boolean
#  communication    :boolean
#  post_event_name  :string
#  post_event_email :string
#  post_event_phone :string
#  creator_id       :integer
#

class Plan < ActiveRecord::Base
  extend SimpleCalendar
  has_paper_trail
  acts_as_commentable
  has_calendar attribute: :start_date
  belongs_to :owner, class_name: User
  belongs_to :event_type
  belongs_to :permitter
  has_many :plan_users
  has_many :users, through: :plan_users
  belongs_to :creator, class_name: User

  has_many :operation_periods

  accepts_nested_attributes_for :event_type, :operation_periods, :owner

  validates_presence_of :name

  scope :like, ->(search) { where("name ilike ?", '%' + search + '%').order(created_at: :desc) }
  scope :alcohol, -> { where("alcohol = ?", true).order(created_at: :desc) }

  include Workflow
  workflow do
    state :draft do
      event :submit, :transitions_to => :awaiting_review
    end
    state :awaiting_review do
      event :review, :transitions_to => :being_reviewed
      event :accept, :transitions_to => :accepted
    end
    state :being_reviewed do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end

  def submit
    puts "I'm sending an email!"
  end

  def review
    puts "under review"
  end

  def accept
    puts "plan accepted"
  end

  def reject
    puts "plan rejected"
  end
end
