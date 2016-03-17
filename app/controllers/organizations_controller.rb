class OrganizationsController < ApplicationController

  load_and_authorize_resource
  
  def index
    @organization_grid = initialize_grid(Organization)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end  

  def create
    @organization = Organization.new(organization_params)
    if !@organization.save
      render action: :new
    else
      redirect_to action: :index
    end
  end

  def update
    if !@organization.update(organization_params)
      render action: :edit
    else
      redirect_to action: :index
    end
  end

  private 

  def organization_params
    params.require(:organization)
    .permit(:name, 
            :phone_number, 
            :address, 
            :email,
            :organization_type_id,
            users_attributes: 
              [:id, 
              :name, 
              :email], 
            organization_types_attributes: 
              [:id, 
              :name, 
              :description])
  end
end
