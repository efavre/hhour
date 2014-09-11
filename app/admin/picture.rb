ActiveAdmin.register Picture do
  
  permit_params :url, :file_key, :author_id, :picture_thread_id

end
