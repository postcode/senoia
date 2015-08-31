class InvitationMailer < ActionMailer::Base
  default from: "Senoia <senoia@senoia.com>"

  def invite(options = { email: nil, plan: nil })
    @plan = options[:plan]
    @email = options[:email]
    mail(to: @email,
         subject: "You have been invited to collaborate on a plan")
  end

end
