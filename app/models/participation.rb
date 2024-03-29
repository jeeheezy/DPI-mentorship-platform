# == Schema Information
#
# Table name: participations
#
#  id         :bigint           not null, primary key
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  program_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_participations_on_program_id  (program_id)
#  index_participations_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#  fk_rails_...  (user_id => users.id)
#
class Participation < ApplicationRecord
  enum role: { mentor: "mentor", mentee: "mentee", admin: "admin" }
  belongs_to :program
  belongs_to :user

  has_many :pairings_as_mentors, foreign_key: "mentor_id", class_name: "Pairing"
  has_many :pairings_as_mentees, foreign_key: "mentee_id", class_name: "Pairing"

  has_many :rankings, foreign_key: "mentee_id", class_name: "Ranking"
  has_many :received_rankings, foreign_key: "mentor_id", class_name: "Ranking"

  accepts_nested_attributes_for :rankings, allow_destroy: true

  validates :user_id, uniqueness: {scope: :program_id }
  validates :role, presence: true
end
