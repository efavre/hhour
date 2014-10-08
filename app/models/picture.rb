class Picture < ActiveRecord::Base

	belongs_to :author, class_name: "User"
	belongs_to :picture_thread
	after_create :notify
	validate :created_before_picture_thread_closing_date, :author_only_submit_once
	validates :file_key, presence: true
	validates :author, presence: true

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
