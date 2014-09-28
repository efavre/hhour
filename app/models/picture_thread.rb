class PictureThread < ActiveRecord::Base
	has_many :pictures
	belongs_to :author, class_name: "User"
	has_and_belongs_to_many :users

	after_create :notify, :set_closing_date

	def set_closing_date
		self.update_attribute(:closing_date, self.created_at + 1.hour}
	end

	def notify
		if Rails.env == "production"
			notifications = []
			Device.all.each do |device|
				notification = Houston::Notification.new(device: device.token)
				notification.alert = "Un nouveau challenge ! #{self.title}"
				notification.badge = 1
				notifications << notification
			end
			APN.push(notifications)
		end
	end
end
