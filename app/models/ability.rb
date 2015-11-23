class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
      can :read, :admin_only_items
    else
      can :manage, Plan, :creator_id => user.id
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can :manage, PostEventTreatmentReport, plan: { creator_id: user.id }
      can :manage, PostEventTreatmentReport, plan: { plan_users: { role: "edit", user_id: user.id } }
      can :manage, TreatmentRecord, post_event_treatment_report: { plan: { creator_id: user.id } }
      can :manage, TreatmentRecord, post_event_treatment_report: { plan: { plan_users: { role: "edit", user_id: user.id } } }
      can :manage, TransportationRecord, post_event_treatment_report: { plan: { creator_id: user.id } }
      can :manage, TransportationRecord, post_event_treatment_report: { plan: { plan_users: { role: "edit", user_id: user.id } } }
      can :manage, ProviderConfirmation, provider: { contact_users: { id: user.id }}
      can :read, :all
      cannot :read, User
      cannot :index, User
    end
    cannot :edit, PostEventTreatmentReport, submitted: true
    cannot [ :edit, :destroy ], TreatmentRecord, post_event_treatment_report: { submitted: true }
    cannot [ :edit, :destroy ], TransportationRecord, post_event_treatment_report: { submitted: true }
  end
end
