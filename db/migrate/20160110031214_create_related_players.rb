class CreateRelatedPlayers < ActiveRecord::Migration
  def change
    create_table :related_players, id: false do |t|
      t.integer :player_id
      t.integer :related_player_id
    end
  
    add_index(:related_players, [:player_id, :related_player_id], :unique => true)
    add_index(:related_players, [:related_player_id, :player_id], :unique => true)
  end
end
