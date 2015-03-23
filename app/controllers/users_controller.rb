class UsersController < ApplicationController

  skip_before_filter :restrict_access, only: [:authenticate]

  def authenticate
    if params.has_key?(:user) && params[:user].has_key?(:facebook_id) && params[:user].has_key?(:facebook_token) && params[:user].has_key?(:facebook_name)
      @user = User.authenticate(params[:user][:facebook_id], params[:user][:facebook_token])
      if @user
        @user.update_attribute(:facebook_name, params[:user][:facebook_name])
        render json:{token:@user.access_token}, status: 200
      else
        head 401
      end
    else
      render json: {message:"missing parameters"}, status:400
    end
  end

end
