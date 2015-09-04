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
  has_many :users_who_can_edit, -> { where(plan_users: { role: "edit" }) }, through: :plan_users, source: :user
  has_many :users_who_can_view, -> { where(plan_users: { role: "view" }) }, through: :plan_users, source: :user
  belongs_to :creator, class_name: User

  has_many :operation_periods
  has_many :comments, as: :commentable
  has_many :invitations, inverse_of: :plan, dependent: :destroy

  accepts_nested_attributes_for :event_type, :operation_periods, :owner

  validates :name, presence: true
  validates :event_type, presence: true

  scope :like, ->(search) { where("name ilike ?", '%' + search + '%').order(created_at: :desc) }
  scope :alcohol, -> { where("alcohol = ?", true).order(created_at: :desc) }
  scope :owner, -> (search) { where("creator_id = ?", search).order(created_at: :desc) }

  scope :attendance, -> (low_number, high_number)  {joins(:operation_periods).where('operation_periods.attendance >= ? AND operation_periods.attendance < ?', low_number, high_number)
  }

  scope :event_type, lambda { |*args| 
    event_type = args[0][:event_type]
    if event_type.empty?
      Plan.all
    else
      Plan.where("event_type_id = ?", event_type).order(created_at: :desc)
    end
  }
  
  scope :with_outstanding_comments, -> { joins(:comment_threads).where(comments: { open: true, parent_id: nil }).uniq }

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
      event :accept, :transitions_to => :accepted, :if => Proc.new(&:all_comments_resolved?)
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end

  def submit
    send_notifications_on_submit
  end

  def review
    send_notifications_on_review
  end

  def accept
    send_notifications_on_accept
  end

  def reject
    send_notifications_on_reject
  end

  def self.a(number)
    Plan.all.collect { |a| a.operation_periods.where("attendance >= ?", number) }.flatten 
  end

  def start_date
    operation_periods.map(&:start_date).compact.min
  end

  def end_date
    operation_periods.map(&:end_date).compact.max
  end

  def attendance
    operation_periods.map(&:attendance).compact.sum
  end

  def to_s
    name
  end

  def all_comments_resolved?
    ! comment_threads.open.exists?
  end
  
  concerning :Notifications do

    def users_to_notify
      [ users, owner, creator ].flatten.compact.uniq
    end
    
    def send_notifications_on_new_comment(comment)
      users_to_notify.reject{ |x| x == comment.user }.each do |stakeholder|
        NotificationMailer.new_comment_notification(recipient: stakeholder, comment: comment).deliver_later
      end
    end

    def send_notifications_on_accept
      users_to_notify.each do |stakeholder|
        NotificationMailer.plan_accepted_notification(recipient: stakeholder, plan: self).deliver_later
      end    
    end

    def send_notifications_on_reject
      users_to_notify.each do |stakeholder|
        NotificationMailer.plan_rejected_notification(recipient: stakeholder, plan: self).deliver_later
      end
    end

    def send_notifications_on_submit
      User.select(&:is_admin?).each do |admin|
        NotificationMailer.plan_submitted_notification(recipient: admin, plan: self).deliver_later
      end
    end

    def send_notifications_on_review
      users_to_notify.each do |stakeholder|
        NotificationMailer.plan_revision_requested_notification(recipient: stakeholder, plan: self).deliver_later
      end
    end

  end
  
end
