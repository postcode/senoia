class AddPlanToProviderConfirmation < ActiveRecord::Migration
  def change
    add_column :provider_confirmations, :plan_id, :integer
  end
end
