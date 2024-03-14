class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :name
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.text :description
      t.string :banner_image
      t.string :support_contact

      t.timestamps
    end
  end
end
