class CommentsController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def index
		if params.has_key?(:picture_id) && Picture.where(id:params[:picture_id]).any?
			@picture = Picture.find(params[:picture_id])
		else
			render json: { message: "missing parameters" }, status:400
		end
	end

	def create
		if params.has_key?(:comment) && params[:comment].has_key?(:user) && params[:comment].has_key?(:content) && params.has_key?(:picture_id) && Picture.where(params[:picture_id])
			author = User.find_or_create_by(first_name: params[:comment][:user])
			@picture = Picture.find(params[:picture_id])
			comment = @picture.comments.build
			comment.comment = params[:comment][:content]
			comment.user = author
			if comment.save
				render action: :index
			else
				render :json => { :errors => comment.errors.full_messages }, :status => 403
			end
		else
			render json: { message: "missing parameters" }, status:400
		end
	end

end
