json.array!(@mates) do |mate|
  json.extract! mate, :id, :name, :number, :image, :instrument
  json.url mate_url(mate, format: :json)
end
