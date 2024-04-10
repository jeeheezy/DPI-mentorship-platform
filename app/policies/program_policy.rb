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
    (user == record.owner) || program_admin?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  private

  def program_admin?
    user.participations.where(program_id: record.id).first.role == "admin"
  end
end
