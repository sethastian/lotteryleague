class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.integer :number
      t.string :title
      t.belongs_to :draft, index: true
      t.timestamps null: false
    end
  end
end
