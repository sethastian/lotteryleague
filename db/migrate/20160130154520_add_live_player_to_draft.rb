class AddLivePlayerToDraft < ActiveRecord::Migration
  def change
    add_column :drafts, :livePlayer, :integer
  end
end
