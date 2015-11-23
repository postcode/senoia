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
  
  def self.claim_invitations(user)
    pending.where(email: user.email).includes(:plan).each do |invitation|
      transaction do
        invitation.plan.plan_users.create(user: user, role: invitation.role)
        invitation.update(invited_user: user)
      end
    end
  end

  def send_invitation_email!
    InvitationMailer.invite(email: email, plan: plan).deliver_later
  end

  def send_collaboration_email!
    InvitationMailer.collaborate(email: email, plan: plan).deliver_later
  end
end
