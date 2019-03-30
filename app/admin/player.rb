ActiveAdmin.register Player do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
active_admin_importable do |model, hash|

    #### IMPORT PLAYERS
    # We need to run import twice. once to import players. once to import related players
    # Make first column 'import_related' to import related

    first = hash[:first].strip
    last = hash[:last].strip
    current_player_name = "#{first} #{last}"

    if hash.to_a[0][0].to_s == "import_related"
      current_player = Player.find_by_email(hash[:email])

      related_players = hash[:list].split(',')

      related_players.each do |related_player|
        name = related_player.squeeze(' ').strip
        related_player_obj = Player.find_by_name(name)

        if !related_player_obj
          Rails.logger.warn("Couldnt find #{name}")
        else
          unless related_player_obj.name == current_player_name
            current_player.related_players << related_player_obj
          end
        end
      end

    else
      if !hash[:first].blank?
        player = model.create!(:name => current_player_name, :email => hash[:email])
      end
    end  


    #if (hash.to_a[1][0].length >= 5)  

    #  if (!hash[:nameimport].blank?)
    #    player = model.create!(:number => hash[:number], :currentBandName => hash[:band], :name => hash[:nameimport], :instrument => hash[:instrument], :phone => hash[:phone], :email => hash[:email], :band2008 => hash[:band2008], :band2010 => hash[:band2010], :band2013 => hash[:band2013], :description => hash[:description])
    #  end

    #### IMPORT RELATED PLAYERS

    #else
    #  for i in 2..hash.length-1
     
    #    if (hash.to_a[i][1].blank?)
    #    else
    #      player = Player.where(name: hash[:name] ).first
    #      related = Player.find_by_name(hash.to_a[i][1])
    #      if (!related.nil?)
    #        player.related_players << related
    #      end
    #    end
    #  end
    #end
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
    column :name
    column "Incompatible Players" do |player|
      player.related_players.each.map{|u| u.name}
    end
    
   	column :instrument
    column :number
    actions
 end

  form do |f|
    f.inputs "Players" do
      f.input :name
      f.input :related_players, as: :select2_multiple, label: "Incompatible Players"
      f.input :number
      f.input :instrument
      f.input :currentBandName
      f.input :phone
      f.input :email
      f.input :band2008
      f.input :band2010
      f.input :band2013
      f.input :image, :required => false, :hint => image_tag(f.object.image.url(:thumb))
      
    end
    f.actions
  end

end
 
  
