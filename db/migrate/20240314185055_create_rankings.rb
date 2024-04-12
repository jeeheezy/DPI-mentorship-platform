class CreateRankings < ActiveRecord::Migration[7.0]
  def change
    create_table :rankings do |t|
      t.references :mentee, null: false, foreign_key: { to_table: :participations }
      t.references :mentor, null: false, foreign_key: { to_table: :participations }
      t.integer :rank

      t.timestamps
    end
  end
end
