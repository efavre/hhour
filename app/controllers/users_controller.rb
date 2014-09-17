class UsersController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def create
		user = User.find_by(first_name: params[:user][:first_name])
		if user
			Device.create(:token => params[:user][:token], :user => user)
		end
		render action: :index
	end

end
