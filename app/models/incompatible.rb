class Incompatible < ActiveRecord::Base
	belongs_to :mate
	belongs_to :incompatibility, :class_name => "Mate"
end
