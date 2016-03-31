class PostEventTreatmentReportMailer < ActionMailer::Base
  default from: "Aram Bronston (SF DEM) <aram.bronston@sfgov.org>"
  layout "mailer"

  def submit(recipient:, plan:)
    @plan = plan
    @post_event_treatment_report = plan.post_event_treatment_report
    @recipient = recipient
    mail(to: @recipient.email,
         subject: "The Post Event Treatment Report has been submitted for plan #{@plan.name}")
  end
end
