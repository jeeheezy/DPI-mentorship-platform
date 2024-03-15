# == Schema Information
#
# Table name: programs
#
#  id              :bigint           not null, primary key
#  banner_image    :string
#  description     :text
#  name            :string
#  support_contact :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :bigint           not null
#
# Indexes
#
#  index_programs_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Program < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :participations

  has_many :participants, through: :participations, source: :user
  has_many :mentor_pairings, through: :participations, source: :pairings_as_mentors
  # can scope this down for pairings where mentee_id is not nil for valid pairings
  has_many :mentor_rankings, through: :participations, source: :rankings
end
