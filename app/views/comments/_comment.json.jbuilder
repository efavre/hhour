json.web_id comment.id.to_s
json.title comment.title
json.content comment.comment
json.user comment.user.try(:display_name)
json.creation_date comment.created_at.to_s