class ProviderConfirmationsController < ApplicationController

  before_action :authenticate_user!
  
  def show
    @provider_confirmation = ProviderConfirmation.find(params[:id])
    authorize! :manage, @provider_confirmation

    @provider = @provider_confirmation.provider
    @medical_asset = @provider_confirmation.medical_asset
    @operation_period = @medical_asset.operation_period
    @plan = @operation_period.plan
  end

  def update
    @provider_confirmation = ProviderConfirmation.find(params[:id])
    authorize! :manage, @provider_confirmation
    if @provider_confirmation.requested?
      if params[:confirm]
        @provider_confirmation.confirm!
      elsif params[:reject]
        @provider_confirmation.reject!
      end
    end
    redirect_to action: :show, status: 303
  end

end


