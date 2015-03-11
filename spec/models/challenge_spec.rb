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
      device1 = FactoryGirl.create(:device)
      device2 = FactoryGirl.create(:device)
      challenge = FactoryGirl.build(:challenge)
      expect(PushNotification).to receive(:notify_message_to_devices).with("Vite ! Une minute pour répondre au défi de #{challenge.author.display_name} : #{challenge.title} !", [device1, device2])
      challenge.save
    end

  end

end
