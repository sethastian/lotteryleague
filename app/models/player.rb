class Player < ActiveRecord::Base
	belongs_to :band

	has_attached_file :image, :styles => { :large => "600x600", :medium => "450x450>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
 	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

has_and_belongs_to_many :related_players,
                          class_name: 'Player',
                          join_table: :related_players,
                          foreign_key: :player_id,
                          association_foreign_key: :related_player_id,
                          uniq: true,
                          finder_sql: proc { %(SELECT DISTINCT "players".* FROM "players"
                                              INNER JOIN "related_players" ON "players"."id" = "related_players"."related_player_id"
                                              WHERE "related_players"."player_id" =  #{self.id}
                                              UNION
                                              SELECT DISTINCT "players".* FROM "players"
                                              INNER JOIN "related_players" ON "players"."id" = "related_players"."player_id"
                                              WHERE "related_players"."related_player_id" =  #{self.id} )}

accepts_nested_attributes_for :related_players


end
