class ChallengesController < ApplicationController

	def index
		@challenges = @current_user.challenges.order("closing_date DESC").limit(15)
		if params[:later_than]
			later_than_date = params[:later_than].to_datetime
			@challenges = @current_user.challenges.where("challenges.created_at > ?", later_than_date).order("closing_date DESC").limit(15)
		end
	end

	def create
		if params.has_key?(:challenge) && params[:challenge].has_key?(:title) && params[:challenge].has_key?(:lasting_time) && params[:challenge].has_key?(:picture) && params[:challenge][:picture].has_key?(:file_key)
			challenge = Challenge.create(title: params[:challenge][:title], author: @current_user, lasting_time_type: params[:challenge][:lasting_time])
			challenge.pictures.create(file_key: params[:challenge][:picture][:file_key], author: @current_user)
			challenge.users << challenge.author
			if params.has_key?(:challengers)
				params[:challengers].each do |challenger_facebook_id|
					challenger = User.find_by(facebook_id: challenger_facebook_id)
					challenge.users << challenger if challenger
				end
			end
			challenge.notify
			render action: :index, status:201
		else
			render json: { message: "missing parameters" }, status:400
		end
	end

end
