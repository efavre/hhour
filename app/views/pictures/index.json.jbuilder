json.pictures @picture_thread.pictures do |picture|
  json.url picture.url
  json.publication_date picture.created_at.to_s
  json.author picture.author.display_name
end