class NotificationMailer < ActionMailer::Base

  default from: "Aram Bronston (SF DEM) <aram.bronston@sfgov.org>"
  layout "mailer"

  def notification(options = { notification: nil })
    @notification = options[:notification]
    @recipient = @notification.owner
    instance_variable_set("@" + @notification.subject_type.underscore, @notification.subject)
    if @plan.present?
      if @plan.approved?
        attachments["#{@plan.name}.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(pdf: 'todo', template: 'plans/pdf/plan.pdf.erb', locals: { plan: @plan})
      )
      end
    end

    mail(to: @recipient.email,
         subject: t(@notification.translation_key,
                    scope: "notification_mailer.subject",
                    subject: @notification.subject))
  end

end
