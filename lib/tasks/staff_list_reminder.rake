class StaffListReminder
  def self.remind(plan, reminder_field)
    # Send the email
    StaffResponsibilityReminderMailer.send_responsibility_reminder(plan).deliver_now

    # Note that we have submitted the reminder.
    plan.update_attribute(reminder_field, true)
  end
end

desc "Send reminder emails about missing staff lists"

task staff_responsibility_reminder: :environment do
  # Find plans due between 8 and 14 days
  two_weeks_out = 8.days.from_now .. 14.days.from_now
  plans = Plan.includes(:supplementary_documents, :operation_periods)
  .where(
    workflow_state: :approved,
    staff_responsibility_reminder_2wk: [false, nil],
    operation_periods: {
      start_date: two_weeks_out
    }
  )

  plans.each do |plan|
    next if plan.deleted?
    if not plan.staff_plan?
      StaffListReminder.remind(plan, 'staff_responsibility_reminder_2wk')
    end
  end

  # Find plans due in the next 7 days
  one_week_out = Time.now.midnight .. 7.days.from_now
  plans = Plan.includes(:supplementary_documents, :operation_periods)
  .where(
    staff_responsibility_reminder_1wk: [false, nil],
    operation_periods: {
      start_date: one_week_out
    }
  )

  plans.each do |plan|
    next if plan.deleted?
    if not plan.staff_plan?
      StaffListReminder.remind(plan, 'staff_responsibility_reminder_1wk')
    end
  end
end
