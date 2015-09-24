class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  storage :fog

  def store_dir
    "#{model.id.to_s.reverse}/#{model.class.to_s.underscore}/"
  end

  process :set_content_type

end
