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
        aws_access_key_id: Rails.application.secrets["aws_access_key_id"],
        aws_secret_access_key: Rails.application.secrets["aws_secret_access_key"],
        region: ENV["s3_region"]
      }

      config.fog_directory = ENV["s3_bucket"]
      config.fog_attributes = { cache_control: "public, max-age=315576000" }

      config.cache_dir = "#{Rails.root}/tmp/uploads"
    end

  else

    puts "Warning: AWS credentials not configured. File uploads won't work."
    
  end
end
