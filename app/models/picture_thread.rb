class PictureThread < ActiveRecord::Base
	has_many :pictures
	belongs_to :author, class_name: "User"
	has_and_belongs_to_many :users
end
