# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  role                   :string           default("guest"), not null
#  organization_id        :integer
#  phone_number           :string
#  roles_mask             :integer
#  name                   :string
#

class User < ActiveRecord::Base
  require 'role_model'
  include RoleModel
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  has_many :collaborated_plans, through: :plan_users, source: :plan
  has_many :created_plans, class_name: "Plan", foreign_key: :creator_id
  has_many :invitations, foreign_key: :invited_user_id, inverse_of: :invited_user
  has_many :notifications,  -> { order("created_at DESC") }, inverse_of: :owner, foreign_key: :owner_id
  has_many :owned_plans, class_name: "Plan", foreign_key: :owner_id
  has_many :plan_users
  has_many :providers, through: :providers_users
  has_many :providers_users
  has_many :organization_users
  has_many :organizations, through: :organizations_users
  has_many :notification_group_memberships, inverse_of: :user, dependent: :destroy
  has_many :notification_groups, through: :notification_group_memberships, source: :notification_group, inverse_of: :members

  roles_attribute :roles_mask

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :admin, :user, :guest, :provider, :promoter, :staff, :permitter

  validates :name, presence: true
  validates :phone_number, presence: true

  scope :to_notify_on, -> (notification_type) do
    if notification_type.present?
      joins(:notification_groups).where("notification_groups.notification_type" => notification_type)
    else
      none
    end
  end

  after_create do
    Invitation.claim_invitations(self)
  end

  def self.find_by_email(email)
    return nil if email.blank?
    User.where("LOWER(email) = ?", email.downcase).first
  end

  def to_s
    if name.blank?
      email
    else
      name
    end
  end

  def affiliated_plans
    Plan.affiliated_to(self)
  end

  def self.pretty_roles
    pretty_roles = { "DEM Admin": :admin, "Event Producer": :producer, "EMS Provider": :provider, "Event Permitter / Staff": :permitter }
  end
end
