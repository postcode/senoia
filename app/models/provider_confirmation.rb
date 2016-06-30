# == Schema Information
#
# Table name: provider_confirmations
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  medical_asset_id   :integer
#  medical_asset_type :string
#  requester_id       :integer
#  workflow_state     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ProviderConfirmation < ActiveRecord::Base

  belongs_to :organization
  belongs_to :medical_asset, polymorphic: true
  belongs_to :requester, class_name: "User"

  validates :organization, presence: true
  validates :medical_asset, presence: true
  validates :organization_id, uniqueness: { scope: [ :medical_asset_id, :medical_asset_type ] }

  include Workflow
  workflow do
    state :requested do
      event :confirm, transitions_to: :confirmed
      event :reject, transitions_to: :rejected
    end
    state :confirmed
    state :rejected
  end

  def deliver_email!
    organization.contact_users.each do |contact|
      ProviderConfirmationMailer.confirm_participation(requester: requester, recipient: contact, confirmation: self).deliver_later
    end
  end

  def to_s
    workflow_state.humanize
  end

end
