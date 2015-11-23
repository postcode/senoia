class AdminController < ApplicationController
  before_filter :verify_is_admin

  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end

 
  private

  def make_sure_someone_is_logged_in
    raise CanCan::AccessDenied.new("Not authorized!") if current_user.nil?
  end

  def verify_is_admin
    (current_user.nil?) ? redirect_to(root_path, alert: "You are not authorized to access this page.") : (redirect_to(root_path, alert: "You are not authorized to access this page.") unless authorize! :read, :admin_only_items)
  end  
end
