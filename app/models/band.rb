class Band < ActiveRecord::Base

	def to_param
   		number
  	end

	has_many :mates
	belongs_to :draft
	has_many :players
end
