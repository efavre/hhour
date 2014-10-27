json.picture_threads @picture_threads do |picture_thread|
  json.web_id picture_thread.id.to_s
  json.title picture_thread.title
  json.author picture_thread.author.display_name
  json.closing_date picture_thread.closing_date.to_s
  json.pictures_count picture_thread.pictures.count
  if picture_thread.pictures.count > 0
    json.original_picture do
      json.web_id picture_thread.pictures.first.id.to_s
  	  json.url picture_thread.pictures.first.get_as3_url
      json.file_key picture_thread.pictures.first.file_key
  	  json.publication_date picture_thread.pictures.first.created_at.to_s
  	  json.author picture_thread.pictures.first.author.display_name
      json.comments_count picture_thread.pictures.first.comments.count
    end
  end
end
