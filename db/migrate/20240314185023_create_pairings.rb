class CreatePairings < ActiveRecord::Migration[7.0]
  def change
    create_table :pairings do |t|
      t.references :mentor, null: false, foreign_key: { to_table: :participations }
      t.references :mentee, null: true, foreign_key: { to_table: :participations }

      t.timestamps
    end
  end
end
