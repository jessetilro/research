class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: :supervisor) # guest user (not logged in)
    if user.contributor?
      project_ids = user.participations.pluck(:project_id)

      can :manage, Source, project_id: project_ids
      can :manage, Project, id: project_ids
      can :manage, Participation, project_id: project_ids, user_id: user.id
      can :manage, Tag, project_id: project_ids

      can :create, Source
      can :create, Project
      can :create, Tag
    end

    can :read, :all
    can :manage, Star, user_id: user.id
    can :manage, Review, user_id: user.id
  end
end
