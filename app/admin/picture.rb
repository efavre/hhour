ActiveAdmin.register Picture do
  
  permit_params :url, :publication_date, :author_id, :picture_thread_id

end
