# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  plan_id         :integer
#  email           :text
#  role            :string
#  invited_user_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Invitation < ActiveRecord::Base
  belongs_to :plan, inverse_of: :invitations
  belongs_to :invited_user, class_name: "User", inverse_of: :invitations
  
  validates :plan, presence: true
  validates :email, presence: true, email: true, uniqueness: { scope: :plan_id, message: "has already been invited" }
  validates :role, presence: true, inclusion: PlanUser::ROLES

  scope :pending, -> { where(invited_user_id: nil) }

  after_create do
    if !self.invited_user && (user = User.find_by_email(email))
      self.claim!(user)
    end
  end

  def claimed?
    self.invited_user.present?
  end
  
  def claim!(user)
    transaction do
      self.plan.plan_users.create(user: user, role: self.role)
      self.update(invited_user: user)
    end
  end
  
  def self.claim_invitations(user)
    pending.where(email: user.email).includes(:plan).each do |invitation|
      invitation.claim!(user)
    end
  end

  def send_notifications!
    user.notifications.create(subject: self, key: "created")
  end

  def send_invitation_email!
    InvitationMailer.invite(email: email, plan: plan).deliver_later
  end

  def to_s
    self.plan.try(:to_s)
  end

end
