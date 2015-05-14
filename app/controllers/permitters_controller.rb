class PermittersController < ApplicationController

  def index
    @permitters = Permitter.all
    respond_to do |format|
      format.html
      format.json { render json: @permitters }
    end
  end

  def show
    @permitter = Permitter.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @permitter = Permitter.new
    respond_to do |format|
      format.html
      format.json { render json: @permitter }
    end
  end  

  def create
    @permitter = Permitter.new(permitter_params)
    if @permitter.save
      redirect_to permitters_path
    else
      redirect_to permitter_new(@permitter), alert: @permitter.errors
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def permitter_params
      params.require(:permitter).permit(:name, :phone_number, :address)
    end
end
