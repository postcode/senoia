class InvitationsController < ApplicationController

  def create
    @plan = Plan.find(params[:plan_id])
    authorize! :manage, @plan
    @invitation = @plan.invitations.create(role: "edit", email: params[:email])
    @invitation.send_invitation_email!
  end

end
