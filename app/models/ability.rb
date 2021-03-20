# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
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


    # All users
    # Can read public articles
    can :show, Article, public: true
    can :index, Article

    # Adding Authorization to Users
    can :index, User
    can :show, User
    can :new, User
    can :create, User

    
    # Additional permissions for logged in users
    if user.present?
      # Read Private Articles under limit
      if user.private_articles_remaining>0
        can :show, Article, public: false
      end
      
      # Can create articles
      can :new, Article
      can :create, Article
      
      # Can edit their own articles
      can :edit, Article, user_id: user.id
      can :update, Article, user_id: user.id
      
      # Can destroy their own articles
      can :destroy, Article, user_id: user.id
      
      # Can edit their own account
      can :edit, User, id: user.id
      can :update, User, id: user.id
      
      # Can destroy their own account
      can :destroy, User, id: user.id
      
    end
    
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
      # Admin can Manage any Article or User Details
      can :edit, Article
      can :update, Article
      can :destroy, Article

      can :edit, User
      can :update, User
      can :destroy, User
    end

  end
end
