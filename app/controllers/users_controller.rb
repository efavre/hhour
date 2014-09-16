class UsersController < ApplicationController

	def create
		user = User.find(:first_name => params[:user][:first_name])
		Device.create(:token => params[:user][:token], :user => user)
	end

end
