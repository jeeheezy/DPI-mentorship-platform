# == Schema Information
#
# Table name: pairings
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mentee_id  :bigint
#  mentor_id  :bigint           not null
#
# Indexes
#
#  index_pairings_on_mentee_id  (mentee_id)
#  index_pairings_on_mentor_id  (mentor_id)
#
# Foreign Keys
#
#  fk_rails_...  (mentee_id => participations.id)
#  fk_rails_...  (mentor_id => participations.id)
#
class Pairing < ApplicationRecord
  belongs_to :mentor, class_name: "Participation"
  belongs_to :mentee, class_name: "Participation"

  belongs_to :programs, through: :mentor
end
