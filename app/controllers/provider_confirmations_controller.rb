class ProviderConfirmationsController < ApplicationController

  def show
    @provider_confirmation = ProviderConfirmation.find(params[:id])
    authorize! :read, @provider_confirmation

    @provider = @provider_confirmation.provider
    @medical_asset = @provider_confirmation.medical_asset
    @operation_period = @medical_asset.operation_period
    @plan = @operation_period.plan
  end

  def update
    @provider_confirmation = ProviderConfirmation.find(params[:id])
    authorize! :manage, @provider_confirmation
    if params[:confirm]
      @provider_confirmation.confirm!
    elsif params[:reject]
      @provider_confirmation.reject!
    end
    redirect_to action: :show, status: 303
  end

end


