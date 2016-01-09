class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
