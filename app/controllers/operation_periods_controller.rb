class OperationPeriodsController < ApplicationController

  def destroy
    @operation_period = OperationPeriod.find(params[:id])
    authorize! :manage, @operation_period.plan
    @operation_period.destroy
  end

end

