class SupplementaryDocument < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  validates :parent, presence: true
  validates :name, presence: true
  validates :file, presence: true
  
  mount_uploader :file, DocumentUploader

  def file=(f)
    # The test environment will send an UploadedFile
    if f.is_a?(String)
      self.remote_file_url = f
    else
      super
    end
  end

end
