ActiveAdmin.register Band do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :number, :player1, :player2, :player3, :player4
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

index do
	id_column
    column :number
    column :player1
    column :player2
    column :player3
    column :player4
    column 'Draft' do |band|
      if band.draft.blank?
        
      else
        link_to band.draft.title, admin_draft_path(band.draft)
      end
    end
    actions
end


end
