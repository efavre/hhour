class ChallengesController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def index
		@challenges = Challenge.all.order("closing_date DESC").limit(15)
		if params[:later_than]
			later_than_date = params[:later_than].to_datetime
			@challenges = Challenge.where("created_at > ?", later_than_date)
		end
	end

	def create
		if params[:challenge] && params[:challenge][:author] && params[:challenge][:title] && params[:challenge][:lasting_time] && params[:challenge][:picture][:file_key]
			author = User.find_or_create_by(first_name: params[:challenge][:author])
			challenge = Challenge.new(title: params[:challenge][:title], author: author, lasting_time_type: params[:challenge][:lasting_time])
			challenge.save
			challenge.pictures.create(file_key: params[:challenge][:picture][:file_key], author: author)
			render action: :index, status:201
		else
			render json: { message: "missing parameters" }, status:400
		end
	end

end
