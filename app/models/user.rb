class User < ActiveRecord::Base
	
	has_many :pictures, foreign_key: "author_id"
	has_many :own_challenges, class_name: "Challenge", foreign_key: "author_id"
	has_many :devices
	has_and_belongs_to_many :challenges

	validates :first_name, presence: true

	def display_name 
		first_name
	end
end
