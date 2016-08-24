class StaffResponsibilityReminderMailer < ActionMailer::Base
  layout "mailer"

  def send_responsibility_reminder(plan)
    @plan = plan
    mail(to: plan.creator.email,
         subject: "A Staff Responsibility list is required for #{@plan.name}")
  end
end
