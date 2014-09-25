class PicturesController < ApplicationController
	
	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	
	def index
		if params[:picture_thread_id]
			picture_thread = PictureThread.find(params[:picture_thread_id])
			@pictures = picture_thread.pictures
			if params[:later_than]
				later_than_date = params[:later_than].to_datetime
				@pictures = picture_thread.pictures.where("created_at > ?",later_than_date)
			end
		end
	end

	#  curl --data "picture[url]=http://test.com/image.jpeg&picture[author]=hodor" http://rails.efa.local/picture_threads/1/pictures.json 
	def create
		if params[:picture_thread_id]
			@picture_thread = PictureThread.find(params[:picture_thread_id])
			if params[:picture][:author]
				author = User.find_or_create_by(first_name: params[:picture][:author])
				@picture_thread.pictures.create(file_key: params[:picture][:file_key], author: author)
			end
		end
		render action: :index
	end
	
end