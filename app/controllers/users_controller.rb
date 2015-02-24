class UsersController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def create
		user = User.find_or_create_by(facebook_id: params[:user][:facebook_id])
		user.update_attribute(first_name, params[:user][:first_name])
		if user
			Device.find_or_create_by(:token => params[:user][:token], :user => user)
		end
		render action: :index
	end

end
