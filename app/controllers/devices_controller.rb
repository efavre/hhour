class DevicesController < ApplicationController

  def create
    if params.has_key?(:user) && params[:user].has_key?(:device_token)
      @current_user.devices.create(token:params[:user][:device_token])
      head 200
    else
      render json: {message:"missing parameters"}, status:400
    end
  end

end
