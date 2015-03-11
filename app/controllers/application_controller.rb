class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :accept_json_only

  private

  def accept_json_only
    render json: { message: "format not acceptable: #{request.format}" }, status:406 unless request.format == "json"
  end

end
