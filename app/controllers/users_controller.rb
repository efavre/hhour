class UsersController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	def create
    if params[:user] && params[:user][:first_name]
      if params[:user][:facebook_id]
    		user = User.find_or_create_by(facebook_id: params[:user][:facebook_id], first_name:params[:user][:first_name])
      else
        user = User.find_or_create_by(first_name: params[:user][:first_name])
      end
      Device.find_or_create_by(:token => params[:user][:token], :user => user)
      render text:"user created", status:200
    else
      render text:"missing parameters", status:400
    end
	end

end
