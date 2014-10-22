class CommentsController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def create
		if params[:comment]
			author = User.find_or_create_by(first_name: params[:comment][:user])
			@picture = Picture.find(params[:picture_id])
			comment = @picture.comments.create
			comment.title = params[:comment][:title]
			comment.comment = params[:comment][:content]
			comment.user = author
			if comment.save
				render action: :index
			else
				render :json => { :errors => comment.errors.full_messages }, :status => 403
			end
		else
			render :json => { :errors => "Missing inputs to create comment" }, :status => 400
		end
	end

	def index
		@picture = Picture.find(params[:picture_id])
	end

end
