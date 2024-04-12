# == Schema Information
#
# Table name: rankings
#
#  id         :bigint           not null, primary key
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mentee_id  :bigint           not null
#  mentor_id  :bigint           not null
#
# Indexes
#
#  index_rankings_on_mentee_id  (mentee_id)
#  index_rankings_on_mentor_id  (mentor_id)
#
# Foreign Keys
#
#  fk_rails_...  (mentee_id => participations.id)
#  fk_rails_...  (mentor_id => participations.id)
#
class Ranking < ApplicationRecord
  belongs_to :mentee_participation, class_name: "Participation", foreign_key: "mentee_id"
  belongs_to :mentor_participation, class_name: "Participation", foreign_key: "mentor_id"

  has_one :program, through: :mentee_participation

  has_one :owner, through: :mentee_participation, source: :user
  has_one :recipient, through: :mentor_participation, source: :user

  # validating for combination of mentor_id and mentee_id since while they can be duplicate while existing separately
  # (e.g. 2 mentees can give the same mentor a rank even if they are in the same program),
  # the combination cannot be duplicate (i.e. a mentee within a program cannot give a mentor in the program more than one rank)
  validates :mentor_id, uniqueness: { scope: :mentee_id }
  validates :rank, presence: true, uniqueness: { scope: :mentee_id }, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 5 } # if mentee chooses not to rank, there would be no ranking created
  validate :same_program

  private

  def same_program
    unless mentor_participation.program == mentee_participation.program
      errors.add(:base, 'A ranking cannot be made outside program')
    end
  end
end
