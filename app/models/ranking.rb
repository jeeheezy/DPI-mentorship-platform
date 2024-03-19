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

  validate :same_program

  private

  def same_program
    unless mentor_participation.program == mentee_participation.program
      errors.add(:base, 'A ranking cannot be made outside program')
    end
  end
end
