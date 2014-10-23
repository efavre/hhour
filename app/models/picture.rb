class Picture < ActiveRecord::Base

	acts_as_commentable

	belongs_to :author, class_name: "User"
	belongs_to :picture_thread
	after_create :notify_other_challengers
	validate :created_before_picture_thread_closing_date, :author_only_submit_once
	validates :file_key, presence: true
	validates :author, presence: true

	def commenters
		self.comments.map{|c| c.user}.uniq
	end

	def created_before_picture_thread_closing_date
		if  self.picture_thread.closing_date == nil || self.picture_thread.closing_date < Time.now
			errors.add(:created_at, "passed thread closing date")
		end
	end

	def author_only_submit_once
		self.picture_thread.pictures.each do |picture|
			if self != picture && picture.author == self.author
				errors.add(:author, "already submitted a picture")
			end
		end
	end

	def notify_other_challengers
		if Rails.env == "production"
			message = "#{self.author.display_name} a répondu au challenge #{self.picture_thread.title}"
			notifications = []
			Device.all.each do |device|
				notification = Houston::Notification.new(device: device.token)
				notification.alert = message
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
