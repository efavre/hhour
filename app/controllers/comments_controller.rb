class CommentsController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def create
		@picture = Picture.find(params[:picture_id])
		comment = @picture.comments.create
		comment.title = params[:comment][:title]
		comment.comment = params[:comment][:comment]
		if comment.save
			render action: :index
		else
			render :json => { :errors => comment.errors.full_messages }, :status => 403
		end
	end

	def index
		@picture = Picture.find(params[:picture_id])
	end

end
