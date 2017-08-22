class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      #can :manage, :all do |s|   #<--- not working for create
      can [:update, :destroy], :all , user_id: user.id #<---- official wiki example
      #---> learned from https://www.youtube.com/watch?v=WNfYQZWNvbk&index=4&list=PL6HtmRWwDtYMuIDt4syZdGXWFPZrAWvm_#t=15.132344
      #---> this also works
      #can [:update, :destroy], :all do |s|
      #  s.user==user
      #end
      can [:read, :create], :all
    else
      can :read, :all
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
