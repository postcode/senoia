class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
      can :manage, Plan, :creator_id => user.id
      can :manage, Plan, :plan_users => { role: "edit", user_id: user.id }
      can :read, :all
    end
  end
end
