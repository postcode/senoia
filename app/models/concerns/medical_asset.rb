module MedicalAsset
  extend ActiveSupport::Concern

  included do
    belongs_to :provider
    belongs_to :operation_period
    has_one :plan, through: :operation_period
    has_one :provider_confirmation, as: :medical_asset

    def create_provider_confirmation
      super(provider: self.provider)
    end

    after_create do
      if provider
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    after_update do
      if provider_id_changed? && provider
        provider_confirmation.try(:destroy)
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end
  end
end
