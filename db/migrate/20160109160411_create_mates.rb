class CreateMates < ActiveRecord::Migration
  def change
    create_table :mates do |t|
      t.string :name
      t.integer :number
      t.attachment :image
      t.string :instrument
      t.belongs_to :band, index: true
      t.timestamps null: false
    end
  end
end
