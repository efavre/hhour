class PictureThreadsController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def index
		@picture_threads = PictureThread.all.order("closing_date DESC")
		if params[:later_than]
			later_than_date = params[:later_than].to_datetime
			@picture_threads = PictureThread.where("created_at > ?", later_than_date)
		end
	end

	def create
		if params[:picture_thread][:author] && params[:picture_thread][:title] && params[:picture_thread][:picture][:file_key]
			author = User.find_or_create_by(first_name: params[:picture_thread][:author])
			picture_thread = PictureThread.create(title: params[:picture_thread][:title], author: author)
			picture_thread.pictures.create(file_key: params[:picture_thread][:picture][:file_key], author: author)
			render action: :index
		else
			render :json => { :errors => "Missing inputs to create picture thread" }, :status => 400
		end
	end

end
