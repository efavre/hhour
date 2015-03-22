class UsersController < ApplicationController

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :restrict_access

	def create
    if params.has_key?(:user) && params[:user].has_key?(:first_name)
      if params[:user].has_key?(:facebook_id)
    		user = User.find_or_create_by(facebook_id: params[:user][:facebook_id], first_name:params[:user][:first_name])
      else
        user = User.find_or_create_by(first_name: params[:user][:first_name])
      end
      Device.find_or_create_by(:token => params[:user][:token], :user => user)
      head 200
    else
      render json: {message:"missing parameters"}, status:400
    end
	end

  def authenticate
    if params.has_key?(:user) && params[:user].has_key?(:facebook_id) && params[:user].has_key?(:facebook_token)
      @user = User.authenticate(params[:user][:facebook_id], params[:user][:facebook_token])
      if @user
        render json:{token:@user.access_token}, status: 200
      else
        head 401
      end
    else
      render json: {message:"missing parameters"}, status:400
    end
  end

end
