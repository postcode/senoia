class ProviderConfirmationMailer < ActionMailer::Base
  
  default from: "Senoia <senoia@senoia.com>"
  layout "mailer"
    
  def confirm_participation(requester:, recipient:, provider:, medical_asset:)
    @requester = requester
    @recipient = recipient
    @provider = provider
    @medical_asset = medical_asset
    @operation_period = @medical_asset.operation_period
    @plan = @medical_asset.plan
    
    mail(to: @recipient.email,
         subject: "Please confirm your participation in #{@plan.name}")
  end

end
