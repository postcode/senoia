# == Schema Information
#
# Table name: supplementary_documents
#
#  id          :integer          not null, primary key
#  name        :text
#  description :text
#  file        :text
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_type :string
#

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
