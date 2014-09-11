class Picture < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	belongs_to :picture_thread

	def get_as3_url
		S3_BUCKET.objects[file_key].url_for(:read).to_s
	end
end
