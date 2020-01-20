# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    else
      can :read, :all
    end
    

    alias_action :create, :read, :update, :destroy, to: :crud

    can :crud, Project do |project|
      project.user == user 
    end

    can :crud, Task do |task|
      task.project.user == user 
      #only project owners can manage the tasks
    end

    can :create, Task do |task|
      task.user == user
      #task user can create but not manage tasks
    end

    can :crud, Discussion do |discussion|
      discussion.user == user || discussion.project.user == user
    end

    can :crud, Comment do |comment|
      user.persisted? && comment.user == user
      #persisted makes sure user is signed in
      #so guest users can't see or changes comments
    end

    # can :reset_password, User do |comment|
    #   user.email == email && token_params == token_params
    # end
    
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

  
  
  
