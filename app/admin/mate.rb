ActiveAdmin.register Mate do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :number, :image, :instrument
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


index do
    column :number
    column :name
   	column :instrument
    actions
 end

  form do |f|
    f.inputs "Mates" do
      f.input :name
      f.input :number
      f.input :instrument
      f.input :image, :required => false, :hint => image_tag(f.object.image.url(:thumb))
      # Will preview the image when the object is edited
    end
    f.actions
  end

end
 
  
