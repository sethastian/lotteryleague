json.array!(@drafts) do |draft|
  json.extract! draft, :id, :title
  json.url draft_url(draft, format: :json)
end
