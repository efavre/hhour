ActiveAdmin.register Picture do
  
  permit_params :url, :file_key, :author_id, :challenge_id

end
