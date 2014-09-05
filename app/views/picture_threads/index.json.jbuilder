json.picture_threads @picture_threads do |picture_thread|
  json.title picture_thread.title
  json.author picture_thread.author.display_name
  json.closing_date picture_thread.closing_date
  json.pictures picture_thread.pictures do |picture|
  	json.url picture.url
  	json.author picture.author.display_name
  	json.publication_date picture.publication_date
  end
end