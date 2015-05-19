# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.mandrillapp.com',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['MANDRILL_USERNAME'],
  :password       => ENV['MANDRILL_PASSWORD'],
  :domain         => 'senioa.com',
  :enable_starttls_auto => true
}
