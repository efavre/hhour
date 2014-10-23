class Comment < ActiveRecord::Base
	include ActsAsCommentable::Comment
	belongs_to :commentable, :polymorphic => true
	belongs_to :user
	default_scope -> { order('created_at ASC') }
	validates :comment, presence: true
	validates :user, presence: true

	after_create :notify_picture_author, :notify_other_commenters

	def notify_picture_author
  		if Rails.env == "production" && self.commentable.author.devices.any?
			message = "#{self.user.display_name} a commenté votre réponse au challenge #{self.commentable.picture_thread.title}"
			notifications = []
			self.commentable.author.devices.each do |device|
				notification = Houston::Notification.new(device: device.token)
				notification.alert = message
				notification.badge = 1
				notifications << notification
			end
			APN.push(notifications)
		end
  	end
  
	def notify_other_commenters
  		if Rails.env == "production"
  			message = "Un nouveau commentaire sur la réponse de #{self.commentable.author.display_name} au challenge #{self.commentable.picture_thread.title}"
	  		notifications = []
	  		self.commentable.commenters.each do |commenter|
	  			if commenter && commenter != self.user && commenter != self.commentable.author
	  	  			commenter.devices.each do |device|
	  	  				notification = Houston::Notification.new(device: device.token)
		    			notification.alert = message
		    			notification.badge = 1
		    			notifications << notification
	  	  			end
	  			end
	  		end
	  		APN.push(notifications)
		end
  	end

end
