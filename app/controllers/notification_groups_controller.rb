class NotificationGroupsController < ApplicationController

  load_and_authorize_resource
  
  def show
  end

  def update
    @notification_group.update(notification_group_params)
    flash[:success] = "Notification group updated."
    redirect_to @notification_group
  end

  private

  def notification_group_params
    params.require(:notification_group).permit(notification_group_memberships_attributes: [ :id, :user_id, :_destroy ])
  end
  
end
