class FacebookConnector < ActiveRecord::Base

  def self.check_access_token(access_token)
    return false
  end

end
