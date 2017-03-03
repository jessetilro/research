class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: :supervisor) # guest user (not logged in)
    if user.contributor?
      can :manage, :all
    elsif user.supervisor?
      can :read, :all
      can :manage, Approval
    end
  end
end
