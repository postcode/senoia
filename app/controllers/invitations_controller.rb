class InvitationsController < ApplicationController

  def create
    @plan = Plan.find(params[:plan_id])
    authorize! :manage, @plan
    if User.where(email: invitation_params[:email]).present?
      @invitation = @plan.invitations.create(invitation_params)
      if @invitation.valid?
        @invitation.send_collaboration_email!
      end
    else
      @invitation = @plan.invitations.create(invitation_params)
      if @invitation.valid?
        @invitation.send_invitation_email!
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email, :role)
  end

end
