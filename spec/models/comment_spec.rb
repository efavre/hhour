require 'rails_helper'

RSpec.describe Comment do

  context "new comment created" do
    
    it "should notify other commenters" do
      Comment.any_instance.stub(:notify_picture_author)
      comment1 = FactoryGirl.create(:comment)
      comment2 = FactoryGirl.build(:comment, :commentable => comment1.commentable)
      expect(PushNotification).to receive(:notify_message_to_devices).with("Un nouveau commentaire sur la réponse de #{comment2.commentable.author.display_name} au challenge #{comment2.commentable.picture_thread.title}", comment1.user.devices)
      comment2.save
    end

    it "should notify picture author" do
      Comment.any_instance.stub(:notify_other_commenters)
      comment = FactoryGirl.build(:comment)
      expect(PushNotification).to receive(:notify_message_to_devices).with("#{comment.user.display_name} a commenté votre réponse au challenge #{comment.commentable.picture_thread.title}", [])
      comment.save
    end

  end
  
end