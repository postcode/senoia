class Invitation < ActiveRecord::Base
  belongs_to :plan, inverse_of: :invitations
  belongs_to :invited_user, class_name: "User", inverse_of: :invitations
  
  validates :plan, presence: true
  validates :email, presence: true, email: true, uniqueness: { scope: :plan_id, message: "has already been invited" }
  validates :role, presence: true, inclusion: PlanUser::ROLES
  
  def self.claim_invitations(user)
    where(email: user.email, invited_user: nil).includes(:plan).each do |invitation|
      transaction do
        invitation.plan.plan_users.create(user: user, role: invitation.role)
        invitation.update(invited_user: user)
      end
    end
  end

  def send_invitation_email!
    InvitationMailer.invite(email: email, plan: plan).deliver_later
  end
end
