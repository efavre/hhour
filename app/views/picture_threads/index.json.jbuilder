json.picture_threads @picture_threads do |picture_thread|
  json.web_id picture_thread.id.to_s
  json.title picture_thread.title
  json.author picture_thread.author.display_name
  json.closing_date picture_thread.closing_date.to_s
  json.original_picture do
  	json.url picture_thread.pictures.first.url
  	json.publication_date picture_thread.pictures.first.created_at.to_s
  	json.author picture_thread.pictures.first.author.display_name
  end
end