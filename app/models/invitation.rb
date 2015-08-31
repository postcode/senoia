class Invitation < ActiveRecord::Base
  belongs_to :plan
  
  validates :plan, presence: true
  validates :email, presence: true
  validates :role, presence: true, inclusion: PlanUser::ROLES

  def self.claim_invitations(user)
    transaction do
      where(email: user.email).each do |invitation|
        invitation.plan.plan_users.create(user: user, role: invitation.role)
        invitation.destroy
      end
    end
  end

  def send_invitation_email!
    InvitationMailer.invite(email: email, plan: plan).deliver_later
  end
end
