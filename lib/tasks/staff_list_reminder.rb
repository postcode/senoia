desc "Send reminder emails about missing staff lists"

def remind(plans, reminder)
  plans.each do |plan|
    print plan.name

    plan.write_attribute(reminder, true)
  end
end


task staff_list_reminder: :environment do
  one_week_out = Time.now.midnight .. 7.days.from_now
  plans = Plan.where(
    staff_responsibility: false,
    staff_responsibility_reminder_1wk: false,
    start_date: two_weeks_out
  )
  remind(plans, 'staff_responsibility_reminder_2wk')

  two_weeks_out = 8.days.from_now .. 14.days.from_now
  plans = Plan.where(
    staff_responsibility: false,
    staff_responsibility_reminder_2wk: false,
    start_date: one_week_out
  )
  remind(plans, 'staff_responsibility_reminder_1wk')
end
