class PairingPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def update?
    program_admin?
  end

  def edit?
    update?
  end

  def destroy?
    program_admin?
  end

  private

  def program_admin?
    program = record.program
    user.participations.find_by(program_id: program.id).admin?
  end
end
