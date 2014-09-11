class PictureThreadsController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def index
		@picture_threads = PictureThread.all
		# render json: @picture_threads.to_json({:only => :title, :include => [{:pictures => {:only => :url}}, {:author => {:only => :first_name}}]})
	end

	def create
		if params[:picture_thread][:author]
			author = User.find_or_create_by(first_name: params[:picture_thread][:author])
			picture_thread = PictureThread.create(title: params[:picture_thread][:title], author: author)
			picture_thread.pictures.create(file_key: params[:picture_thread][:picture][:file_key], author: author)
		end
		render action: :index
	end

end
