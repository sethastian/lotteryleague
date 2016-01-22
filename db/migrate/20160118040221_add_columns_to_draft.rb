class AddColumnsToDraft < ActiveRecord::Migration
  def change
    add_column :drafts, :liveBand, :string
    add_column :drafts, :round, :string
  end
end
