json.array!(@incompatibles) do |incompatible|
  json.extract! incompatible, :id, :mate_id, :incompatibility_id
  json.url incompatible_url(incompatible, format: :json)
end
