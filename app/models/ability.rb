class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    elsif user.id?
      can :manage, Plan, creator_id: user.id
      can :manage, Plan, plan_users: { role: "edit", user_id: user.id }
      can :create, Comment, commentable: { users_who_can_edit: { id: user.id } }
      can :read, Plan, plan_users: { role: "view", user_id: user.id }
      can :manage, ProviderConfirmation, provider: { contact_users: { id: user.id }}
    else
      can :read, Plan, { workflow_state: "accepted" }
    end
  end
end
