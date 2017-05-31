class NotificationGroupsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction

  def show
    @users = User.includes(:notification_group_memberships).order("#{sort_column} #{sort_direction}")
  end

  def update
    @notification_group.update(notification_group_params)
    flash[:success] = "Notification group updated."
    redirect_to @notification_group
  end

  private

  def notification_group_params
    params.require(:notification_group).permit(notification_group_memberships_attributes: [:id, :user_id, :_destroy])
  end

  def sortable_columns
    ["name", "email", "roles_mask", "notification_group_memberships.id"]
  end

  def sort_column
    column = params[:column]
    if params[:column] == "notification_group_memberships"
      column = "notification_group_memberships.id"
    end
    sortable_columns.include?(column) ? column : "email"
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end
end
