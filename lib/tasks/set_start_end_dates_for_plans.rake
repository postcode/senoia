desc "set start and end dates for existing plans"
task set_start_end_date: :environment do
  Plan.all.each do |plan|
    plan.start_datetime = plan.start_date if plan.start_datetime.nil?
    plan.end_datetime = plan.end_date if plan.end_datetime.nil?
    plan.save!
  end
end
