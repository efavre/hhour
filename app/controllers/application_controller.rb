class ApplicationController < ActionController::Base  

  protect_from_forgery with: :exception
  before_filter :accept_json_only, :restrict_access

  protected

  def accept_json_only
    render json: { message: "format not acceptable: #{request.format}" }, status:406 unless request.format == "json"
  end

  def check_params(provided_params, expected_params)
    if expected_params
      expected_params.each do |expected_param|
        if expected_param.is_a? Hash
          expected_param.each do |expected_param_key, expected_param_value|
            if provided_params.has_key?(expected_param_key)
              return check_params(provided_params[expected_param_key], expected_param_value)
            else
              return false
            end
          end
        else
          if ! provided_params.has_key?(expected_param)
            return false
          end
        end
      end
    end
    return true        
  end
  
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(access_token: token)
    end
  end

end
