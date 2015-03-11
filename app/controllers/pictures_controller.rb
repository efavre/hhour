class PicturesController < ApplicationController
	
	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	
	def index
		if params[:challenge_id] && Challenge.find(params[:challenge_id])
			challenge = Challenge.find(params[:challenge_id])
			@pictures = challenge.pictures
			if params[:later_than]
				later_than_date = params[:later_than].to_datetime
				@pictures = challenge.pictures.where("created_at > ?",later_than_date)
			end
		else
			render :json => { :errors => "No picture thread found" }, :status => 400
		end
	end

	#  curl --data "picture[url]=http://test.com/image.jpeg&picture[author]=hodor" http://rails.efa.local/challenges/1/pictures.json 
	def create
		if params[:challenge_id] && Challenge.find(params[:challenge_id])
			@challenge = Challenge.find(params[:challenge_id])
			if params[:picture][:author]
				author = User.find_or_create_by(first_name: params[:picture][:author])
				picture = @challenge.pictures.create(file_key: params[:picture][:file_key], author: author)
				if picture.valid?
					render action: :index
				else
					render :json => { :errors => picture.errors.full_messages }, :status => 403
				end
			else
				render :json => { :errors => "No author" }, :status => 400
			end
		else
			render :json => { :errors => "No picture thread found" }, :status => 400
		end
	end
	
end