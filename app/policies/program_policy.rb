class ProgramPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    if user_in_program?
      (user == record.owner) || program_admin?
    else
      false
    end
  end

  def edit?
    update?
  end

  def destroy?
    if user_in_program?
      (user == record.owner) || program_admin?
    else
      false
    end
  end

  private
  def user_in_program?
    user.participations.where(program_id: record.id).any?
  end

  def program_admin?
    user.participations.find_by(program_id: record.id).admin?
  end
end
