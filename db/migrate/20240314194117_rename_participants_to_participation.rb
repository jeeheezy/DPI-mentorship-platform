class RenameParticipantsToParticipation < ActiveRecord::Migration[7.0]
  def change
    rename_table :participants, :participations
  end
end
