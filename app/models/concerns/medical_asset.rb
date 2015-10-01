module MedicalAsset
  extend ActiveSupport::Concern

  included do
    belongs_to :provider
    belongs_to :operation_period
    has_one :plan, through: :operation_period
    has_one :provider_confirmation, as: :medical_asset, dependent: :destroy

    def create_provider_confirmation
      super(provider: self.provider, requester: Current.user)
    end

    after_create do
      if provider && operation_period
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    after_update do
      if provider_id_changed? || operation_period_id_changed? && (provider && operation_period)
        provider_confirmation.try(:destroy)
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    def to_s
      name
    end
  end
end
