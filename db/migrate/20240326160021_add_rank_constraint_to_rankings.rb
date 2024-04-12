class AddRankConstraintToRankings < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :rankings, "(rank > 0 AND rank <= 5)", name: "rank_constraint"
  end
end
