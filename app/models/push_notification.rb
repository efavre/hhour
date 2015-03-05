class PushNotification < ActiveRecord::Base

  	def self.notify_message_to_devices(message, devices)
  		if message && devices && Rails.env == "production"
	  		notifications = []
  			devices.each do |device|
	  		  notification = Houston::Notification.new(device: device.token)
		    	notification.alert = message
		   	 	notification.badge = 1
				  notification.sound = 'default'
		    	notifications << notification
	  		end
	  		APN.push(notifications)
	  	end
  	end

end
