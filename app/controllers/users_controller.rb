class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [ :new, :edit, :show, :update, :create, :index ]
  skip_before_filter :require_no_authentication, only: :create
  load_and_authorize_resource

  def index
    @user_grid = initialize_grid(User,
      order:           'name',
      order_direction: 'asc')
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def show
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:notice] = "Account has been disabled"
      redirect_to :action => :index
    else
      render action: "edit"
    end
  end

  def create
    if params[:user][:password].blank?
      [ :password, :password_confirmation ].collect{|p| params[:user].delete(p) }
    end
    @user = User.new(user_params)
    @user.roles << :user
    if @user.save
      flash[:notice] = "User created."
      redirect_to action: :index
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      [ :password, :password_confirmation ].collect{|p| params[:user].delete(p) }
    end

    if @user.update(user_params)
      flash[:notice] = "User updated."
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def user_params
    permitted_params = [ :name, :email, :phone_number, :password, :password_confirmation, organization_users_attributes: [:id, :name] ]
    permitted_params << :roles if can? :manage, User
    params.require(:user).permit(permitted_params)
  end

end
