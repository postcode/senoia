class ProviderConfirmationMailer < ActionMailer::Base
  
  default from: "Aram Bronston <aram.bronston@sfgov.org>"
  layout "mailer"
    
  def confirm_participation(requester:, recipient:, confirmation:)
    @requester = requester
    @recipient = recipient
    @confirmation = confirmation
    @provider = @confirmation.provider
    @medical_asset = @confirmation.medical_asset
    @operation_period = @medical_asset.operation_period
    @plan = @medical_asset.plan
    
    mail(to: @recipient.email,
         subject: "Please confirm your participation in #{@plan.name}")
  end

end
