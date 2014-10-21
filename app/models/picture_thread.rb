class PictureThread < ActiveRecord::Base

	has_many :pictures
	belongs_to :author, class_name: "User"
	has_and_belongs_to_many :users
	
	after_create :set_closing_date, :notify

	validates :title, presence: true
	validates :author, presence: true

	def set_closing_date
		if self.is_hour_challenge?
			self.update_attribute(:closing_date, self.created_at + 60.hours)
		elsif self.is_second_challenge?
			self.update_attribute(:closing_date, self.created_at + 60.seconds)
		else
			self.update_attribute(:closing_date, self.created_at + 60.minutes)
		end
	end

	def notify
		message = "Vous avez 60 heures pour repondre au défi de #{self.author.display_name} : #{self.title}."
		if self.is_second_challenge?
			message = "Vite ! Une minute pour répondre au défi de #{self.author.display_name} : #{self.title} !"
		elsif self.is_minute_challenge?
			message = "#{self.author.display_name} vous lance le défi #{self.title} ! On ramasse les copies dans une heure." 
		end
		if Rails.env == "production"
			notifications = []
			Device.all.each do |device|
				notification = Houston::Notification.new(device: device.token)
				notification.sound = 'default'
				notification.alert = message
				notification.badge = 1
				notifications << notification
			end
			APN.push(notifications)
		end
	end

	def is_hour_challenge?
		return self.lasting_time_type == "h"
	end

	def is_minute_challenge?
		return self.lasting_time_type == "m"
	end

	def is_second_challenge?
		return self.lasting_time_type == "s"
	end
end
