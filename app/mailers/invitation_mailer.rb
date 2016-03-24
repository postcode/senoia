class InvitationMailer < ActionMailer::Base
  default from: "Senoia <senoia@senoia.com>"
  layout "mailer"

  def invite(options = { email: nil, plan: nil })
    @plan = options[:plan]
    @email = options[:email]
    mail(to: @email,
         subject: "You have been invited to collaborate on the medical plan #{@plan.name}")
  end
end
