ActiveAdmin.register Draft do

after_create do |draft|
    for i in 1..draft.numberOfBands
	   	@band = Band.new(number: i, draft: draft)
	   	@band.save
	end
end

permit_params :title, :liveBand, :round, :numberOfBands


# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
