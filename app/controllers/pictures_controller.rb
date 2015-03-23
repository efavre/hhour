class PicturesController < ApplicationController
	
	def index
 		if params.has_key?(:challenge_id) && Challenge.where(id:params[:challenge_id]).any?
			@challenge = Challenge.find(params[:challenge_id])
			@pictures = @challenge.pictures
			if params.has_key?(:later_than)
				later_than_date = params[:later_than].to_datetime
				@pictures = @challenge.pictures.where("created_at > ?",later_than_date)
			end
		else
			render json: { message: "missing parameters" }, status:400
		end
	end

	def create
		if params.has_key?(:challenge_id) && Challenge.where(id:params[:challenge_id]).any?
			@challenge = Challenge.find(params[:challenge_id])

			if params.has_key?(:picture) && params[:picture].has_key?(:file_key)
				picture = @challenge.pictures.create(file_key: params[:picture][:file_key], author: @current_user)
				if picture.valid?
					render action: :index, status:201
				else
					render :json => { :errors => picture.errors.full_messages }, status:403
				end
			else
				render json: { message: "missing parameters" }, status:400
			end
		else
			render json: { message: "missing parameters" }, status:400
		end
	end
	
end