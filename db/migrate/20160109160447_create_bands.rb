class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.integer :number
      t.string :title
      t.string :player1
      t.string :player2
      t.string :player3
      t.string :player4
      t.belongs_to :draft, index: true
      t.timestamps null: false
    end
  end
end
