class PermittersController < ApplicationController

  load_and_authorize_resource
  
  def index
    @permitters = Permitter.all
    @permitter_grid = initialize_grid(Permitter)
    respond_to do |format|
      format.html
      format.json { render json: @permitters }
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
      format.json { render json: @permitter }
    end
  end  

  def create
    @permitter = Permitter.new(permitter_params)
    if !@permitter.save
      render action: :new
    else
      redirect_to action: :index
    end
  end

  def update
    if !@permitter.update(permitter_params)
      render action: :edit
    else
      redirect_to action: :index
    end
  end

  private 

  def permitter_params
    params.require(:permitter).permit(:name, :phone_number, :address, :email)
  end
end
