class Comment < ActiveRecord::Base
	include ActsAsCommentable::Comment
	belongs_to :commentable, :polymorphic => true
	belongs_to :user
	default_scope -> { order('created_at ASC') }
	validates :comment, presence: true
	validates :user, presence: true

	after_create :notify_picture_author, :notify_other_commenters

	def notify_picture_author
		message = "#{self.user.display_name} a commenté votre réponse au challenge #{self.commentable.challenge.title}"
		PushNotification.notify_message_to_devices(message, self.commentable.author.devices.uniq)
  end
  
	def notify_other_commenters
		message = "Un nouveau commentaire sur la réponse de #{self.commentable.author.display_name} au challenge #{self.commentable.challenge.title}"
		PushNotification.notify_message_to_devices(message, get_devices_to_notify)	  		
  end

  def get_devices_to_notify
    devices = []
    self.commentable.commenters.each do |commenter|
      if commenter != self.commentable.author && commenter != self.user
        devices << commenter.devices 
      end
    end
    devices.flatten.uniq
  end

end
