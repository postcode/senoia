namespace :populate do

  task :special_events_approval_notification_group => :environment do
    url = "https://github.com/postcode/senoia/files/182245/Special.Event.Plan.Approval.Notification.Group.txt"

    users = open(url).read.split("\r\n").reject(&:blank?)[2..-1].map{|x| x.split("\t") }.map do |name, email|
      user = User.where("LOWER(email) = ?", email.strip.downcase).first
      if user
        puts "#{email} already exists"
      else
        user = User.create(name: name.strip, email: email.strip.downcase, password: SecureRandom.hex(16), phone_number: "N/A")
        puts "Created account for #{email}"
      end
      user
    end

    notification_group = NotificationGroup.where(notification_type: "plan.approved").first_or_create
    notification_group.update(name: "Special Events Approval Notification Group", description: "Members of this group will be notified of any approved plans.")
    
    users.each do |user|
      membership_relation = NotificationGroupMembership.where(notification_group_id: notification_group.id, user_id: user.id)
      if membership_relation.any?
        puts "#{user.email} already in notification group"
      else
        membership_relation.first_or_create
        puts "#{user.email} added to notification group"
      end

    end
    
  end
  
end
