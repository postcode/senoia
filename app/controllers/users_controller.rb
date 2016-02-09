class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [ :new, :edit, :show, :update, :create, :index ] 
  skip_before_filter :require_no_authentication, only: :create
  load_and_authorize_resource

  def index
    @users = User.all
  end
 
  def new
  end

  def show
  end

  def edit
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
    permitted_params = [ :name, :email, :phone_number, :password, :password_confirmation ]
    permitted_params << :roles if can? :manage, User
    params.require(:user).permit(permitted_params)
  end
  
end
