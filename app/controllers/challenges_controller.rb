class ChallengesController < ApplicationController

	def index
		@challenges = Challenge.all.order("closing_date DESC").limit(15)
		if params[:later_than]
			later_than_date = params[:later_than].to_datetime
			@challenges = Challenge.where("created_at > ?", later_than_date)
		end
	end

	def create
		if params.has_key?(:challenge) && params[:challenge].has_key?(:title) && params[:challenge].has_key?(:lasting_time) && params[:challenge].has_key?(:picture) && params[:challenge][:picture].has_key?(:file_key)
			challenge = Challenge.new(title: params[:challenge][:title], author: @current_user, lasting_time_type: params[:challenge][:lasting_time])
			challenge.save
			challenge.pictures.create(file_key: params[:challenge][:picture][:file_key], author: @current_user)
			render action: :index, status:201
		else
			render json: { message: "missing parameters" }, status:400
		end
	end

end
