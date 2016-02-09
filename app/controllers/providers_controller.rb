class ProvidersController < ApplicationController
  load_and_authorize_resource
  
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

  def edit
    @provider = Provider.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @provider = Provider.find(params[:id])
    respond_to do |format|
      if @provider.update(provider_params)
        if params[:providers_user].present?
          @provider.save_provider_users(params[:providers_user][:user_ids])
        end
        format.html { redirect_to @provider, notice: 'Provider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
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
      if params[:provider_user].present?
          @provider.save_provider_users(params[:provider_user][:user_ids])
        end
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
      params.require(:provider).permit(:name, :phone_number, :address,  
               users_attributes: [
                 :id,
                 :email,
                 :password,
                 :address,
                 :roles,
                 :roles_mask,
                 :phone_number
                ])
    end
end
