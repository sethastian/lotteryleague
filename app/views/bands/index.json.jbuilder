json.array!(@bands) do |band|
  json.extract! band, :id, :number, :title
  json.url band_url(band, format: :json)
end
