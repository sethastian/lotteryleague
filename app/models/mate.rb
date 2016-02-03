class Mate < ActiveRecord::Base
	belongs_to :band
	has_attached_file :image, :styles => { :large => "600x600", :medium => "450x450>", :thumb => "100x100>" }, :default_url => "/images/mystery.jpg"
 	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
