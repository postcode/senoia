class SupplementaryDocument < ActiveRecord::Base
  belongs_to :plan

  validates :plan, presence: true
  validates :name, presence: true

  mount_uploader :file, DocumentUploader

  def file_url=(new_file_url)
    self.remote_file_url = new_file_url
  end

end
