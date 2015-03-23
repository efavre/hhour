class FacebookConnector < ActiveRecord::Base

  def self.check_access_token(facebook_id, facebook_token)
    return true
  end

end
