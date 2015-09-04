class NotificationsController < ApplicationController

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.update(notification_params)
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end
  
end


