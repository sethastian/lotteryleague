class CreateIncompatibles < ActiveRecord::Migration
  def change
    create_table :incompatibles do |t|
      t.integer :mate_id
      t.integer :incompatibility_id

      t.timestamps null: false
    end
  end
end
