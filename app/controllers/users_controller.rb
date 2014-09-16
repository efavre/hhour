class UsersController < ApplicationController

	def create
		user = User.find_by(first_name: params[:user][:first_name])
		if user
			Device.create(:token => params[:user][:token], :user => user)
		end
		render nothing: true
	end

end
