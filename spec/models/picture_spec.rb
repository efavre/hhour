require 'rails_helper'

RSpec.describe Picture do

  context "Picture created before challenge closes" do 

    it "is valid" do
      challenge = FactoryGirl.create(:challenge)
      picture = FactoryGirl.build(:picture, challenge:challenge)
      expect(picture.valid?).to be(true)
    end

  end

  context "Picture created before challenge closes" do 

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

      challenge = FactoryGirl.create(:challenge)
      device1 = FactoryGirl.create(:device)
      device2 = FactoryGirl.create(:device)
      picture1 = FactoryGirl.create(:picture, author:device1.user, challenge:challenge)
      picture2 = FactoryGirl.build(:picture, author:device2.user, challenge:challenge)

      expect(PushNotification).to receive(:notify_message_to_devices).with("#{picture2.author.display_name} a répondu au challenge #{challenge.title}", [device1, device2])
      picture2.save
    end

  end
end

