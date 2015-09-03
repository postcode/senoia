class NotificationMailer < ActionMailer::Base

  default from: "Senoia <senoia@senoia.com>"

  def notification(options = { notification: nil })
    @notification = options[:notification]
    @recipient = @notification.owner
    instance_variable_set("@" + @notification.subject_type.underscore, @notification.subject)
    
    mail(to: @recipient.email,
         subject: t(@notification.translation_key,
                    scope: "notification_mailer.subject",
                    subject: @notification.subject))
  end

end
