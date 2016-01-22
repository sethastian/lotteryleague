class Band < ActiveRecord::Base
	has_many :mates
	belongs_to :draft
	has_many :players
end
