class ProviderConfirmationsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_plan

  def show
    @provider = @provider_confirmation.organization
  end

  def update
    if @provider_confirmation.requested?
      if params[:confirm]
        @provider_confirmation.confirm!
      elsif params[:reject]
        @provider_confirmation.reject!
      end
    end
    redirect_to action: :show, status: 303
  end

  private

  def find_plan
    @provider_confirmation = ProviderConfirmation.find(params[:id])
    @medical_asset = @provider_confirmation.medical_asset
    @operation_period = @medical_asset.operation_period
    @plan = @operation_period.plan
  end
end
