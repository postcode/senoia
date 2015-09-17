class ProviderConfirmation < ActiveRecord::Base

  belongs_to :provider
  belongs_to :medical_asset, polymorphic: true
  belongs_to :requester, class_name: "User"

  validates :provider, presence: true
  validates :medical_asset, presence: true
  validates :provider_id, uniqueness: { scope: [ :medical_asset_id, :medical_asset_type ] }
  
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
    provider.contact_users.each do |contact|
      ProviderConfirmationMailer.confirm_participation(requester: requester, recipient: contact, confirmation: self).deliver_later
    end
  end
end
