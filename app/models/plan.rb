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
  has_many :supplementary_documents

  accepts_nested_attributes_for :event_type, :operation_periods, :owner

  validates :name, presence: true
  validates :event_type, presence: true
  
  scope :with_outstanding_comments, -> { joins(:comment_threads).where(comments: { open: true, parent_id: nil }).uniq }
  
  include Workflow
  workflow do
    state :draft do
      event :submit, :transitions_to => :under_review
    end
    state :under_review do
      event :request_revision, :transitions_to => :revision_requested
      event :approve, :transitions_to => :approved
    end
    state :revision_requested do
      event :approve, :transitions_to => :approved, :if => Proc.new(&:all_comments_resolved?)
      event :reject, :transitions_to => :rejected
    end
    state :approved
    state :rejected
  end

  def submit
    send_notifications_on_submit
  end

  def request_revision
    send_notifications_on_request_revision
  end

  def approve
    send_notifications_on_approve
  end

  def reject
    send_notifications_on_reject
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

  concerning :Search do

    included do
      scope :affiliated_to, -> (user) { where("owner_id = ? OR creator_id = ? OR plans.id IN(?)", user.id, user.id, user.collaborated_plans.select(:id)) }
      scope :calculating_total_attendance, -> { joins("LEFT JOIN (SELECT plan_id, SUM(attendance) AS total_attendance FROM operation_periods GROUP BY plan_id) join_total_attendance ON join_total_attendance.plan_id = plans.id")}
      scope :calculating_start_date, -> { joins("LEFT JOIN (SELECT plan_id, MIN(start_date) as start_date FROM operation_periods GROUP BY plan_id) join_start_date ON join_start_date.plan_id = plans.id")}
      scope :calculating_end_date, -> { joins("LEFT JOIN (SELECT plan_id, MIN(end_date) as end_date FROM operation_periods GROUP BY plan_id) join_end_date ON join_end_date.plan_id = plans.id")}
      scope :like, ->(search) { where("plans.name ilike ?", '%' + search + '%') }
      scope :alcohol, -> { where("alcohol = ?", true) }
      scope :owner, -> (search) { where("creator_id = ?", search) }

      scope :event_type, lambda { |*args| 
        event_type = args[0][:event_type]
        if event_type.empty?
          Plan.all
        else
          Plan.where("event_type_id = ?", event_type)
        end
      }
    end

    class_methods do

      def search(options)
        scope = all
        scope = scope.like(options[:filter]) if options[:filter]
        scope = scope.alcohol if options[:alcohol] == '1'

        if options[:start_date].present?
          scope = scope.calculating_end_date
          scope = scope.where("end_date >= ?", options[:start_date])
        end
          
        if options[:end_date].present?
          scope = scope.calculating_start_date
          scope = scope.where("start_date <= ?", options[:end_date])
        end

        if options[:state]
          scope = scope.filter_by_state(options[:state])
        end
        
        if options[:attendance]
          scope = scope.filter_by_attendance(options[:attendance])
        end

        if options[:event_type]
          scope = scope.filter_by_event_type(options[:event_type])
        end

        scope
      end

      def filter_by_event_type(options)
        event_type_ids = options.map{ |id, selected| id if selected == "1" }.compact
        if event_type_ids.any?
          where(event_type_id: event_type_ids)
        else
          all
        end
      end

      def filter_by_state(options)
        selected_states = options.map { |state, selected| state if selected == "1" }.compact

        if selected_states.any?
          where(workflow_state: selected_states)
        else
          all
        end
      end

      ATTENDANCE_FILTERS = {
        "2500" => [ 0, 2500 ],
        "2500_15500" => [ 2500, 15500 ],
        "15500_50000" => [ 15500, 50000 ],
        "50000" => [ 50000, nil ]
      }

      def filter_by_attendance(options)
        query_fragments = ATTENDANCE_FILTERS.map do |key, range|
          if options[key] == "1"
            attendance_query(range)
          else
            nil
          end
        end.compact

        where(query_fragments.join(" OR "))
      end

      def attendance_query(range)
        query = sanitize_sql([ "total_attendance >= ?", range.first ])
        if range.last
          query = query + sanitize_sql([ " AND total_attendance <= ?", range.last ])
        end
        "(#{query})"
      end
    end
  end
  
  concerning :Notifications do
    
    def send_notifications_on_new_comment(comment)
      stakeholders.reject{ |x| x == comment.user }.each do |stakeholder|
        stakeholder.notifications.create(subject: comment, key: "created")
      end
    end

    def send_notifications_on_submit
      User.select(&:is_admin?).each do |admin|
        admin.notifications.create(subject: self, key: "submitted")
      end
    end

    def send_notifications_on_request_revision
      notify_stakeholders("revision_requested")
    end

    def send_notifications_on_approve
      notify_stakeholders("approved")
    end

    def send_notifications_on_reject
      notify_stakeholders("rejected")
    end
    
    def stakeholders
      [ users, owner, creator ].flatten.compact.uniq
    end

    def notify_stakeholders(key)
      stakeholders.each do |stakeholder|
        stakeholder.notifications.create(subject: self, key: key)
      end
    end

  end
  
end
