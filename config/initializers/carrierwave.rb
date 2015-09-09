require 'carrierwave/processing/mime_types'

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: Rails.application.secrets["aws_access_key_id"],
    aws_secret_access_key: Rails.application.secrets["aws_secret_access_key"],
    region: ENV["CARRIERWAVE_REGION"]
  }

  config.fog_directory = ENV["CARRIERWAVE_S3_BUCKET"]
  config.fog_attributes = { cache_control: "public, max-age=315576000" }

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
