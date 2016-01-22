json.array!(@players) do |player|
  json.extract! player, :id, :name, :number, :instrument, :image, :email, :practiceLocation
  json.url player_url(player, format: :json)
end
