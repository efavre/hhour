class Picture < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	belongs_to :picture_thread
end
