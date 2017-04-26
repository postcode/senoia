class InvitationsController < ApplicationController
  def create
    @plan = Plan.find(params[:plan_id])
    authorize! :manage, @plan
    @invitation = @plan.invitations.create(invitation_params)

    return unless @invitation.valid?
    if @invitation.claimed? # User already has an account, send notification
      users = User.where(email: invitation_params[:email])
      @invitation.send_notifications!(users)
    else # User doesn't have an account, send invitation
      @invitation.send_invitation_email!
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email, :role)
  end
end
