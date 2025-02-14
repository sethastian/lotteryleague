class Player < ActiveRecord::Base
	belongs_to :band

	has_attached_file :image, :styles => { :large => "600x600", :medium => "450x450>", :thumb => "100x100>" }, :default_url => ActionController::Base.helpers.asset_path('mystery2.jpg')
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


	def front_image
		return "" if !self.name || self.name.blank?
		names = self.name.split(" ")
		parsed_name = names[0].downcase + "_" + names[1].downcase

		"/assets/player_fronts/#{parsed_name}.png"
	end

	def back_image
		return "" if !self.name || self.name.blank?
		names = self.name.split(" ")
		parsed_name = names[0].downcase + "_" + names[1].downcase

		"/assets/player_backs/#{parsed_name}.png"
	end

end
