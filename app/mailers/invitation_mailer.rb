class InvitationMailer < ActionMailer::Base
  default from: "Senoia <senoia@senoia.com>"

  def invite(options = { email: nil, plan: nil })
    mail(to: options[:email],
         subject: "You have been invited to collaborate on a plan")
  end

end
