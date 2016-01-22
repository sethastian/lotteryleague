class Draft < ActiveRecord::Base
	has_many :bands, dependent: :destroy
end
