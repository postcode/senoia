require 'carrierwave/processing/mime_types'

if Rails.env.test?

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

else

  if Rails.application.secrets["aws_access_key_id"]
    
    CarrierWave.configure do |config|

      config.fog_credentials = {
        provider: "AWS",
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV["S3_REGION"]
      }

      config.fog_directory = ENV["S3_BUCKET"]
      config.fog_attributes = { cache_control: "public, max-age=315576000" }

      config.cache_dir = "#{Rails.root}/tmp/uploads"
    end

  else

    puts "Warning: AWS credentials not configured. File uploads won't work."
    
  end
end

