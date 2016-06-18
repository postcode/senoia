module MedicalAsset
  extend ActiveSupport::Concern

  included do
    belongs_to :organization
    belongs_to :operation_period
    has_one :plan, through: :operation_period
    has_one :provider_confirmation, as: :medical_asset, dependent: :destroy

    def create_provider_confirmation
      super(organization: self.organization, requester: Current.user)
    end

    after_create do
      if organization && operation_period
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    after_update do
      if organization_id_changed? || operation_period_id_changed? && (organization && operation_period)
        provider_confirmation.try(:destroy)
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    def provider
      organization if organization.present? && organization.organization_type.name == "Event Producer"
    end

    def to_s
      name
    end
  end
end
