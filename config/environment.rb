# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.postmarkapp.com",
  :port                 => 25,
  :domain               => 'sfdemmedicalplans.com',
  :user_name            => ENV['POSTMARK_API_TOKEN'],
  :password             => ENV['POSTMARK_API_TOKEN'],
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}
