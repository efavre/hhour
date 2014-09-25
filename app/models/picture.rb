class Picture < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	belongs_to :picture_thread
	after_create :notify

	def notify
		if Rails.env == "production"
			notifications = []
			Device.all.each do |device|
				notification = Houston::Notification.new(device: device.token)
				notification.alert = "Une nouvelle réponse au challenge #{self.picture_thread.title}"
				notification.badge = 1
				notifications << notification
			end
			APN.push(notifications)
		end
	end

	def get_as3_url
		S3_BUCKET.objects[file_key].url_for(:read).to_s
	end

end
