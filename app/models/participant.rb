# == Schema Information
#
# Table name: participants
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
#  index_participants_on_program_id  (program_id)
#  index_participants_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#  fk_rails_...  (user_id => users.id)
#
class Participant < ApplicationRecord
  belongs_to :program
  belongs_to :user
end
