class PicturesController < ApplicationController

	def index
		if params[:picture_thread_id]
			@picture_thread = PictureThread.find(params[:picture_thread_id])
		end
	end

end
