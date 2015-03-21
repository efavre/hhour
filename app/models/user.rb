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
    user = User.find_or_create_by(facebook_id:facebook_id)
    if FacebookConnector.check_access_token(facebook_id, facebook_token)
      user.update_attribute(:facebook_token, facebook_token)
      user.generate_access_token
      return user
    else
      user.update_attribute(:facebook_token, nil)
      return nil
    end
  end
  
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
