class Band < ActiveRecord::Base

	#def to_param
   	#	number
  	#end

	has_many :mates
	belongs_to :draft
	has_many :players


	def fill_last_slot(player_num)
		%w[2 3 4].each do |num|
			if self.send("player#{num}").blank?
				self.update("player#{num}".to_sym => player_num)
				self.players << Player.where(number: player_num.to_i).first
				break
			else
				next
			end
		end
	end

	def replace_last_player(player_num)
		%w[4 3 2 1].each do |num|
			if self.send("player#{num}").blank?
				next
			else
				self.update("player#{num}".to_sym => player_num)
				self.players << Player.where(number: player_num.to_i).first
				break
			end
		end
	end

end
