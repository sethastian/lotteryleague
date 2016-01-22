class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :number
      t.string :instrument
      t.attachment :image
      t.string :email
      t.text :practiceLocation
      t.belongs_to :band, index: true
      t.timestamps null: false
    end
  end
end
