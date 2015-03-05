class Comment < ActiveRecord::Base
	include ActsAsCommentable::Comment
	belongs_to :commentable, :polymorphic => true
	belongs_to :user
	default_scope -> { order('created_at ASC') }
	validates :comment, presence: true
	validates :user, presence: true

	after_create :notify_picture_author, :notify_other_commenters

	def notify_picture_author
		message = "#{self.user.display_name} a commenté votre réponse au challenge #{self.commentable.picture_thread.title}"
		PushNotification.notify_message_to_devices(message, self.commentable.author.devices)
  end
  
	def notify_other_commenters
		message = "Un nouveau commentaire sur la réponse de #{self.commentable.author.display_name} au challenge #{self.commentable.picture_thread.title}"
  	all_commenters = self.commentable.commenters
  	all_commenters_but_self_and_picture_author = all_commenters.delete_if{|user| (user == self.user) || (user == self.commentable.author)}
  	devices = all_commenters_but_self_and_picture_author.map{|user| user.devices}.flatten
		PushNotification.notify_message_to_devices(message, devices)	  		
  end

end
