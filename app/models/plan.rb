# == Schema Information
#
# Table name: plans
#
#  id                                :integer          not null, primary key
#  name                              :string
#  owner_id                          :integer
#  alcohol                           :boolean
#  created_at                        :datetime
#  updated_at                        :datetime
#  event_type_id                     :integer
#  organization_id                   :integer
#  workflow_state                    :string
#  event_contact                     :text
#  responsibility                    :boolean
#  cpr                               :boolean
#  communication                     :boolean
#  post_event_name                   :string
#  post_event_email                  :string
#  post_event_phone                  :string
#  creator_id                        :integer
#  venue_id                          :integer
#  communication_phone               :string
#  staff_responsibility              :boolean
#  mci                               :boolean          default(FALSE)
#  approval_date                     :datetime
#  staff_responsibility_reminder_1wk :boolean
#  staff_responsibility_reminder_2wk :boolean
#  deleted                           :boolean          default(FALSE)
#  deleted_reason                    :text
#  start_datetime                    :datetime
#  end_datetime                      :datetime
#

class Plan < ActiveRecord::Base
  has_paper_trail
  acts_as_commentable
  is_impressionable
  belongs_to :owner, class_name: User
  belongs_to :event_type
  has_many :plan_users
  has_many :users, through: :plan_users
  has_many :users_who_can_edit, -> { where(plan_users: { role: "edit" }) }, through: :plan_users, source: :user
  has_many :users_who_can_view, -> { where(plan_users: { role: "view" }) }, through: :plan_users, source: :user
  belongs_to :creator, class_name: User

  has_many :operation_periods
  has_many :comments, as: :commentable
  has_many :invitations, inverse_of: :plan, dependent: :destroy
  has_many :supplementary_documents, as: :parent
  has_many :transports, -> { uniq }, through: :operation_periods

  has_one :post_event_treatment_report
  has_one :communication_plan
  has_many :plan_venues
  has_many :venues, through: :plan_venues

  belongs_to :organization

  accepts_nested_attributes_for :event_type, :operation_periods, :owner, :supplementary_documents

  validates :name, presence: true
  validates :event_type, presence: true
  # validates :post_event_name, presence: true
  # validates :post_event_email, presence: true
  # validates :post_event_phone, presence: true

  scope :with_outstanding_comments, -> { joins(:comment_threads).where(comments: { open: true, parent_id: nil }).uniq }
  scope :deleted, -> { where(deleted: true) }
  scope :active, -> { where(deleted: false) }

  scope :creator_find_plans, (lambda do |search|
    joins(:creator).where("users.name ILIKE (?) OR users.email ILIKE (?)", "%#{search}%", "%#{search}%")
  end)

  include Workflow
  workflow do
    state :draft do
      event :submit, transitions_to: :under_review
    end
    state :under_review do
      event :request_revision, transitions_to: :revision_requested
      event :approve, transitions_to: :approved
      event :provisionally_approve, transitions_to: :provisionally_approved
    end
    state :revision_requested do
      event :approve, transitions_to: :approved, if: Proc.new(&:all_comments_resolved?)
      event :request_review, transitions_to: :under_review
      event :reject, transitions_to: :rejected
      event :provisionally_approve, transitions_to: :provisionally_approved
    end
    state :provisionally_approved do
      event :approve, transitions_to: :approved, if: Proc.new(&:all_comments_resolved?)
      event :request_review, transitions_to: :under_review
      event :reject, transitions_to: :rejected
    end
    state :approved do
      on_entry do
        update_attributes(approval_date: Time.current)
        self
      end
    end
    state :rejected
  end

  def submit
    send_notifications_on_submit
  end

  def request_revision
    send_notifications_on_request_revision
  end

  def request_review
    send_notifications_on_request_review
  end

  def provisionally_approve
    send_notifications_on_provisional
  end

  def approve
    send_notifications_on_approve
  end

  def reject
    send_notifications_on_reject
  end

  def email_approved
    send_notifications_on_approve
  end

  def add_start_end_dates
    update_attributes(start_datetime: start_date, end_datetime: end_date)
    p self
  end

  def start_date
    d = operation_periods.map(&:start_date).compact.min
    t = operation_periods.map(&:start_time).compact.min
    DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day, t.hour, t.min) if d.present? && t.present?
  end

  def staff_plan?
    supplementary_documents.staff_contact.exists?
  end

  def end_date
    d = operation_periods.map(&:end_date).compact.max
    t = operation_periods.map(&:end_time).compact.max
    if d.present? && t.present?
      DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day, t.hour, t.min)
    end
  end

  def total_plan_period
    if start_date == end_date
      "#{start_date.strftime('%l:%M%p on %A %B %e, %Y')}"
    else
      "#{start_date.strftime('%l:%M%p on %A %B %e, %Y')} until #{end_date.strftime('%l:%M%p on %A %B %e, %Y')}"
    end
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

  def permitter
    organization if organization.present? && organization.organization_type.name == "Event Permitter"
  end

  def add_permitter_contact
    return unless permitter.present?
    permitter.organization_users.default_contact.map { |u| plan_users.create(user: u.user, role: "edit") unless users.include?(u.user) }
  end

  def last_updated
    User.find(versions.last.whodunnit) if versions.last.whodunnit
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
      scope :deleted_plans, -> { where("deleted = ?", true) }


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
        if options[:deleted_plans] == '1'
          scope = scope.deleted_plans
        else
          scope = Plan.active
        end
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

        if options[:creator]
          scope = scope.creator_find_plans(options[:creator])
        end

        scope
      end

      def filter_by_event_type(options)
        event_type_ids = options.map { |id, selected| id if selected == "1" }.compact
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
        query = sanitize_sql(["total_attendance >= ?", range.first])
        if range.last
          query = query + sanitize_sql([" AND total_attendance <= ?", range.last])
        end
        "(#{query})"
      end
    end
  end

  concerning :Notifications do
    def send_notifications_on_new_comment(comment)
      stakeholders.reject { |x| x == comment.user }.each do |stakeholder|
        stakeholder.notifications.create(subject: comment, key: "created")
      end
    end

    def send_notifications_on_submit
      User.select(&:is_admin?).each do |admin|
        admin.notifications.create(subject: self, key: "submitted")
      end
    end

    def send_notifications_on_request_revision
      notify_owner("revision_requested")
    end

    def send_notifications_on_request_review
      notify_owner("review_requested")
    end

    def send_notifications_on_approve
      notify_stakeholders("approved")
    end

    def send_notifications_on_provisional
      notify_stakeholders("provisional")
    end

    def send_notifications_on_reject
      notify_stakeholders("rejected")
    end

    def stakeholders
      [users, owner, creator].flatten.compact.uniq
    end

    def owners
      [owner, creator, User.admins].flatten.compact.uniq
    end

    def notify_owner(key)
      users_to_notify = (owners + User.to_notify_on("plan.#{key}")).uniq
      users_to_notify.each do |stakeholder|
        stakeholder.notifications.create(subject: self, key: key)
      end
    end

    def notify_stakeholders(key)
      users_to_notify = (stakeholders + User.to_notify_on("plan.#{key}")).uniq
      users_to_notify.each do |stakeholder|
        stakeholder.notifications.create(subject: self, key: key)
      end
    end
  end
end
