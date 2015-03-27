require 'rails_helper'

RSpec.describe Challenge do

  context "60 seconds challenge" do
    
    before(:each) do
      @challenge = FactoryGirl.create(:challenge, lasting_time_type:"s")
    end

    it "is_second_challenge?" do
      expect(@challenge.is_second_challenge?).to be(true)
      expect(@challenge.is_minute_challenge?).to be(false)
      expect(@challenge.is_hour_challenge?).to be(false)
    end

    it "closes 60 seconds from creation" do
      expect(@challenge.closing_date).to eq(@challenge.created_at + 60.seconds)
    end

  end

  context "60 minutes challenge" do

    before(:each) do
      @challenge = FactoryGirl.create(:challenge, lasting_time_type:"m")
    end

    it "is_second_challenge?" do
      expect(@challenge.is_second_challenge?).to be(false)
      expect(@challenge.is_minute_challenge?).to be(true)
      expect(@challenge.is_hour_challenge?).to be(false)
    end

    it "closes 60 seconds from creation" do
      expect(@challenge.closing_date).to eq(@challenge.created_at + 60.minutes)
    end

  end

  context "60 hours challenge" do

    before(:each) do
      @challenge = FactoryGirl.create(:challenge, lasting_time_type:"h")
    end
  
    it "is_second_challenge?" do
      expect(@challenge.is_second_challenge?).to be(false)
      expect(@challenge.is_minute_challenge?).to be(false)
      expect(@challenge.is_hour_challenge?).to be(true)
    end

    it "closes 60 seconds from creation" do
      expect(@challenge.closing_date).to eq(@challenge.created_at + 60.hours)
    end

  end

  context "creating new challenge" do

    it "notifies users" do
      user_with_devices1 = FactoryGirl.create(:user_with_devices)
      user_with_devices2 = FactoryGirl.create(:user_with_devices)
      challenge = FactoryGirl.create(:challenge)
      challenge.users = [user_with_devices1, user_with_devices2]
      expect(PushNotification).to receive(:notify_message_to_devices).with("Vite ! Une minute pour répondre au défi de #{challenge.author.display_name} : #{challenge.title} !", [user_with_devices1.devices.first, user_with_devices2.devices.first])
      challenge.notify
    end

  end

end
