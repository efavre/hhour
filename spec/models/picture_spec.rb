require 'rails_helper'

RSpec.describe Picture do

  context "Picture created before challenge closes" do 

    it "is valid" do
      challenge = FactoryGirl.create(:challenge)
      picture = FactoryGirl.build(:picture, challenge:challenge)
      expect(picture.valid?).to be(true)
    end

  end

  context "Picture created after challenge closes" do 

    it "is not valid" do
      challenge = FactoryGirl.create(:challenge)
      challenge.update_attribute(:closing_date, 1.hour.ago)
      picture = FactoryGirl.build(:picture, challenge:challenge)
      expect(picture.valid?).to be(false)
    end

  end

  context "Author has not replied to challenge yet" do 

    it "is valid" do
      author = FactoryGirl.create(:user)
      challenge = FactoryGirl.create(:challenge)
      picture = FactoryGirl.build(:picture, challenge:challenge,author:author)
      expect(picture.valid?).to be(true)
    end

  end

  context "Author has already replied to challenge" do 

    it "is not valid" do
      author = FactoryGirl.create(:user)
      challenge = FactoryGirl.create(:challenge)

      picture1 = FactoryGirl.create(:picture,author:author)
      picture1.update_attribute(:challenge, challenge)

      picture2 = FactoryGirl.build(:picture,author:author)
      picture2.challenge = challenge
      expect(picture2.valid?).to be(false)
    end

  end


  context "creating new challenge" do

    it "notifies users" do
      user_with_devices1 = FactoryGirl.create(:user_with_devices)
      user_with_devices2 = FactoryGirl.create(:user_with_devices)
      challenge = FactoryGirl.create(:challenge)
      challenge.users = [user_with_devices1, user_with_devices2]
      picture1 = FactoryGirl.create(:picture, author:user_with_devices1, challenge:challenge)
      picture2 = FactoryGirl.build(:picture, author:user_with_devices2, challenge:challenge)

      expect(PushNotification).to receive(:notify_message_to_devices).with("#{picture2.author.display_name} a répondu au challenge #{challenge.title}", [user_with_devices1.devices.first, user_with_devices2.devices.first])
      picture2.save
    end

  end
end

