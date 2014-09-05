json.picture_threads @picture_threads do |picture_thread|
  json.title picture_thread.title
  json.author picture_thread.author.display_name
  json.closing_date picture_thread.closing_date
  json.original_picture do
  	json.url picture_thread.pictures.first.url
  	json.publication_date picture_thread.pictures.first.publication_date
  end
end