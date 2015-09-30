class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
      can :manage, Plan, :creator_id => user.id
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can :manage, ProviderConfirmation, provider: { contact_users: { id: user.id }}
      can :read, :all
      cannot :index, User
      can :update, User, id: user.id
    end
  end
end
