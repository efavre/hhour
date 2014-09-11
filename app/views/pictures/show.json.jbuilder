json.web_id picture.id.to_s
json.url picture.get_as3_url
json.file_key picture.file_key
json.publication_date picture.created_at.to_s
json.author picture.author.display_name