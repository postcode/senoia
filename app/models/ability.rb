class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :read, :admin_only_items
      can :manage, :all
    elsif user.has_role? :promoter
      can :manage, Plan, :creator_id => user.id
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can [:create, :edit, :update, :read], Plan
      can [:create, :edit, :update, :read], Comment
    elsif user.has_role? :provider
      can :manage, Plan, :creator_id => user.id
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can [:create, :edit, :update, :read], Plan
      can [:create, :edit, :update, :read], Comment
    elsif user.has_role? :permitter
      can [:edit, :update, :read], Plan
      can [:create, :edit, :update, :read], Comment
    elsif user.has_role? :user
      can :create, Plan
    else
      can :manage, Plan, :creator_id => user.id
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can :manage, PostEventTreatmentReport, plan: { creator_id: user.id }
      can :manage, PostEventTreatmentReport, plan: { plan_users: { role: "edit", user_id: user.id } }
      can :manage, CommunicationPlan, plan: { plan_users: { role: "edit", user_id: user.id } }
      can :manage, TreatmentRecord, post_event_treatment_report: { plan: { creator_id: user.id } }
      can :manage, TreatmentRecord, post_event_treatment_report: { plan: { plan_users: { role: "edit", user_id: user.id } } }
      can :manage, TransportationRecord, post_event_treatment_report: { plan: { creator_id: user.id } }
      can :manage, TransportationRecord, post_event_treatment_report: { plan: { plan_users: { role: "edit", user_id: user.id } } }
      can :manage, ProviderConfirmation, provider: { contact_users: { id: user.id }}
      can :read, :all
      cannot :read, User
      cannot :index, User
      cannot [:create, :edit, :destroy], Plan
      cannot :read, Provider
      cannot :read, Permitter
      cannot :read, NotificationGroup
      can :read, Plan, workflow_state: :approved
    end
    cannot :edit, PostEventTreatmentReport, submitted: true
    cannot [ :edit, :destroy ], TreatmentRecord, post_event_treatment_report: { submitted: true }
    cannot [ :edit, :destroy ], TransportationRecord, post_event_treatment_report: { submitted: true }
  end
end
