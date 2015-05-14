class ProvidersController < ApplicationController

  def index
    @providers = Provider.all
    respond_to do |format|
      format.html
      format.json { render json: @providers }
    end
  end

  def show
    @provider = Provider.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @provider = Provider.new
    respond_to do |format|
      format.html
      format.json { render json: @provider }
    end
  end  

  def create
    @provider = Provider.new(provider_params)
    if @provider.save
      redirect_to providers_path
    else
      redirect_to provider_new(@provider), alert: @provider.errors
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def provider_params
      params.require(:provider).permit(:name, :phone_number, :address)
    end
end
