ActiveAdmin.register Player do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
active_admin_importable do |model, hash|

    #### IMPORT PLAYERS
    
    if (hash.to_a[1][0].length >= 5)  

      if (!hash[:nameimport].blank?)
        player = model.create!(:number => hash[:number], :currentBandName => hash[:band], :name => hash[:nameimport], :instrument => hash[:instrument], :phone => hash[:phone], :email => hash[:email], :band2008 => hash[:band2008], :band2010 => hash[:band2010], :band2013 => hash[:band2013], :description => hash[:description])
      end

    #### IMPORT RELATED PLAYERS

    else
      for i in 2..hash.length-1
     
        if (hash.to_a[i][1].blank?)
        else
          player = Player.where(name: hash[:name] ).first
          related = Player.find_by_name(hash.to_a[i][1])
          if (!related.nil?)
            player.related_players << related
          end
        end
      end
    end
end


permit_params :name, :number, :phone, :currentBandName, :band2008, :band2010, :band2013, :image, :instrument, :email, :practiceLocation, :related_player_id, :player_id, :players, related_player_ids: [], related_players: []



#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


index do
    selectable_column
    id_column
    column :number
    column :name
   	column :instrument
    actions
 end

  form do |f|
    f.inputs "Players" do
      f.input :name
      f.input :number
      f.input :instrument
      f.input :currentBandName
      f.input :phone
      f.input :email
      f.input :band2008
      f.input :band2010
      f.input :band2013
      f.input :image, :required => false, :hint => image_tag(f.object.image.url(:thumb))
      f.input :related_players, as: :select2_multiple, label: "Incompatible Players"
    end
    f.actions
  end

end
 
  
