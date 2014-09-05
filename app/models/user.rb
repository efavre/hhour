class User < ActiveRecord::Base
	has_many :pictures, foreign_key: "author_id"
	has_many :own_picture_threads, class_name: "PictureThread", foreign_key: "author_id"
	has_and_belongs_to_many :picture_threads

	def display_name 
		first_name
	end

	def to_builder
    	Jbuilder.new do |user|
      		user.(self, :first_name)
    	end
  	end
end
