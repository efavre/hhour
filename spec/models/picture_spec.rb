require 'rails_helper'

RSpec.describe Picture do

  context "Picture created before challenge closes" do 

    it "is valid" do
      picture_thread = FactoryGirl.create(:picture_thread)
      picture = FactoryGirl.build(:picture, picture_thread:picture_thread)
      expect(picture.valid?).to be(true)
    end

  end

  context "Picture created before challenge closes" do 

    it "is not valid" do
      picture_thread = FactoryGirl.create(:picture_thread)
      picture_thread.update_attribute(:closing_date, 1.hour.ago)
      picture = FactoryGirl.build(:picture, picture_thread:picture_thread)
      expect(picture.valid?).to be(false)
    end

  end

  context "Author has not replied to challenge yet" do 

    it "is valid" do
      author = FactoryGirl.create(:user)
      picture_thread = FactoryGirl.create(:picture_thread)
      picture = FactoryGirl.build(:picture, picture_thread:picture_thread,author:author)
      expect(picture.valid?).to be(true)
    end

  end

  context "Author has already replied to challenge" do 

    it "is not valid" do
      author = FactoryGirl.create(:user)
      picture_thread = FactoryGirl.create(:picture_thread)

      picture1 = FactoryGirl.create(:picture,author:author)
      picture1.update_attribute(:picture_thread, picture_thread)

      picture2 = FactoryGirl.build(:picture,author:author)
      picture2.picture_thread = picture_thread
      expect(picture2.valid?).to be(false)
    end

  end


  context "creating new challenge" do

    it "notifies users" do

      picture_thread = FactoryGirl.create(:picture_thread)
      device1 = FactoryGirl.create(:device)
      device2 = FactoryGirl.create(:device)
      picture1 = FactoryGirl.create(:picture, author:device1.user, picture_thread:picture_thread)
      picture2 = FactoryGirl.build(:picture, author:device2.user, picture_thread:picture_thread)

      expect(PushNotification).to receive(:notify_message_to_devices).with("#{picture2.author.display_name} a répondu au challenge #{picture_thread.title}", [device1, device2])
      picture2.save
    end

  end
end

