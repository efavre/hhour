json.challenges @challenges do |challenge|
  json.web_id challenge.id.to_s
  json.title challenge.title
  json.author challenge.author.display_name
  json.closing_date challenge.closing_date.to_s
  json.pictures_count challenge.pictures.count
  if challenge.pictures.count > 0
    json.original_picture do
      json.web_id challenge.pictures.first.id.to_s
  	  json.url challenge.pictures.first.get_as3_url
      json.file_key challenge.pictures.first.file_key
  	  json.publication_date challenge.pictures.first.created_at.to_s
  	  json.author challenge.pictures.first.author.display_name
      json.comments_count challenge.pictures.first.comments.count
    end
  end
end
