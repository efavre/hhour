class Picture < ActiveRecord::Base

	acts_as_commentable

	belongs_to :author, class_name: "User"
	belongs_to :challenge
	after_create :notify_other_challengers
	validate :created_before_challenge_closing_date, :author_only_submit_once
	validates :file_key, presence: true
	validates :author, presence: true

	def commenters
		self.comments.map{|c| c.user}.uniq
	end

	def created_before_challenge_closing_date
		if  self.challenge.closing_date == nil || self.challenge.closing_date < Time.now
			errors.add(:created_at, "passed thread closing date")
		end
	end

	def author_only_submit_once
		self.challenge.pictures.each do |picture|
			if self != picture && picture.author == self.author
				errors.add(:author, "already submitted a picture")
			end
		end
	end

	def notify_other_challengers
		message = "#{self.author.display_name} a répondu au challenge #{self.challenge.title}"
		PushNotification.notify_message_to_devices(message, self.challenge.get_devices_to_notify)
	end

	def get_as3_url
		S3_BUCKET.objects[file_key].url_for(:read, { :expires => 1.month.from_now, :secure => true }).to_s
	end

end
