class CreateSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :spots do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.text :description
      t.string :image_url
      t.text :memo

      t.timestamps
    end
  end
end
