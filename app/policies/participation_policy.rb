class ParticipationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # for now letting anybody join any program
  def create?
    true
  end

  def new?
    create?
  end

  # program admin can update or delete any participations belonging to the program
  def update?
    if user_in_program?
      (user == record.user) || program_admin?
    else
      false
    end
  end

  def edit?
    update?
  end

  def destroy?
    if user_in_program?
      (user == record.user) || program_admin?
    else
      false
    end
  end

  private

  def user_in_program?
    program = record.program
    user.participations.where(program_id: program.id).any?
  end

  def program_admin?
    program = record.program
    user.participations.find_by(program_id: program.id).admin?
  end
end
