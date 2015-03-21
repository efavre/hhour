class User < ActiveRecord::Base
	
	has_many :pictures, foreign_key: "author_id"
	has_many :own_challenges, class_name: "Challenge", foreign_key: "author_id"
	has_many :devices
	has_and_belongs_to_many :challenges

	validates :first_name, presence: true

	def display_name 
		first_name
	end

  def self.authenticate(facebook_id, facebook_token)
    if FacebookConnector.check_access_token(facebook_token)
      user = User.find_or_create_by(facebook_id:facebook_id)
      user.update_attribute(:facebook_token,facebook_token)
      return user
    else
      return nil
    end
  end

end
