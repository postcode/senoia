class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :read, :admin_only_items
      can :manage, :all
    elsif (user.has_role? :user) || (user.has_role? :producer )|| (user.has_role? :provider) || (user.has_role? :permitter)
      can :read, :user_only_items
      can :view, Plan, :plan_users => { role: "view", user_id: user.id }
      can :create, Plan
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can :manage, Plan, :creator_id => user.id
      can :manage, Comment
      cannot :resolve, Comment
    elsif user.has_role? :guest
      can [:create, :edit, :update, :read], Comment
      cannot [:create, :edit, :destroy, :manage], Plan
      cannot [:edit, :manage], Plan do |p|
        user.id.blank?
        p.creator_id.blank?
      end

      can :view, Plan, plan_users: { role: "view", user_id: user.id }
      can [:edit, :manage], Plan, plan_users: { role: "edit", user_id: user.id }
      can :manage, PostEventTreatmentReport, plan: { creator_id: user.id }
      can :manage, PostEventTreatmentReport, plan: { plan_users: { role: "edit", user_id: user.id } }
      can :manage, CommunicationPlan, plan: { plan_users: { role: "edit", user_id: user.id } }
      can :manage, TreatmentRecord, post_event_treatment_report: { plan: { creator_id: user.id } }
      can :manage, TreatmentRecord, post_event_treatment_report: { plan: { plan_users: { role: "edit", user_id: user.id } } }
      can :manage, TransportationRecord, post_event_treatment_report: { plan: { creator_id: user.id } }
      can :manage, TransportationRecord, post_event_treatment_report: { plan: { plan_users: { role: "edit", user_id: user.id } } }
      can :manage, ProviderConfirmation, provider: { contact_users: { id: user.id }}
      cannot :read, User
      cannot :index, User
      cannot :read, Provider
      cannot :read, Permitter
      cannot :read, NotificationGroup
      can :view, Plan do |plan|
       plan.approved?
      end
      can :manage, Plan, creator_id: user.id
    else
      cannot :read, User
      cannot :index, User
      cannot [:create, :view, :edit, :destroy], Plan
      can :view, Plan, plan_users: { role: "view", user_id: user.id }
      can [:edit, :view], Plan, plan_users: { role: "edit", user_id: user.id }
      can :view, Plan do |plan|
       plan.approved?
      end
    end
    cannot :edit, PostEventTreatmentReport, submitted: true
    cannot [ :edit, :destroy ], TreatmentRecord, post_event_treatment_report: { submitted: true }
    cannot [ :edit, :destroy ], TransportationRecord, post_event_treatment_report: { submitted: true }
  end
end
