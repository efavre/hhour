class PictureThreadsController < ApplicationController

	def index
		@picture_threads = PictureThread.all
		# render json: @picture_threads.to_json({:only => :title, :include => [{:pictures => {:only => :url}}, {:author => {:only => :first_name}}]})
	end

end
