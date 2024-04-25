class RankingPolicy < ApplicationPolicy
  attr_reader :user, :record
  # record will be a mentee participation or nil, so can just check truthy or falsey

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    record
  end

  def update?
    record
  end
end
