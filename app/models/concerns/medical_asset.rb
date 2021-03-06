module MedicalAsset
  extend ActiveSupport::Concern

  included do
    belongs_to :organization
    belongs_to :operation_period
    has_one :plan, through: :operation_period
    has_one :provider_confirmation, as: :medical_asset, dependent: :destroy

    default_scope { order('created_at ASC') }

    def create_provider_confirmation
      super(organization: self.organization, requester: Current.user, plan: operation_period.plan)
    end

    after_create do
      next if clone?
      if organization && operation_period
        next if exisiting_confirmation?
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    after_update do
      next if clone?
      if organization_id_changed? || operation_period_id_changed? && (organization && operation_period)
        provider_confirmation.try(:destroy)
        create_provider_confirmation
        provider_confirmation.deliver_email!
      end
    end

    def provider
      organization if organization.present? && organization.organization_type.name == "EMS Provider"
    end

    def to_s
      name
    end

    def exisiting_confirmation?
      ProviderConfirmation.where(plan_id: operation_period.plan.id, organization_id: organization.id).present?
    end
  end
end
