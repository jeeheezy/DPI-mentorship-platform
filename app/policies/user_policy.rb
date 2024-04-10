class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def show?
    is_current_user? || same_program?
  end

  # not sure if the update/destroy things will be necessary/work since authorization skips over devise controllers

  def update?
    is_current_user?
  end

  def edit?
    update?
  end

  def destroy?
    is_current_user?
  end

  private

  def is_current_user?
    user == current_user
  end 

  def same_program?
    user1_programs = current_user.involved_programs.pluck(:id)
    user2_programs = user.involved_programs.pluck(:id)
    shared_programs = user1_programs.intersection(user2_programs)
    shared_programs.any?
  end
end
