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
#  fk_rails_...  (mentee_id => participants.id)
#  fk_rails_...  (mentor_id => participants.id)
#
class Ranking < ApplicationRecord
  belongs_to :mentee
  belongs_to :mentor
end
