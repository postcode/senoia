desc "remove all nil times"
task add_default_time: :environment do
  OperationPeriod.all.each do |op|
    p op.start_time.nil?
    if op.start_time.nil?
      op.start_time = Time.local(2000,1,1,20,15,1)
    end
    if op.end_time.nil?
      op.end_time = Time.local(2000,1,1,20,15,1)
    end
    op.save!
  end
end