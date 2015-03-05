require 'rails_helper'

RSpec.describe PictureThread do

  context "60 seconds challenge" do
    
    before(:each) do
      @picture_thread = FactoryGirl.create(:picture_thread, lasting_time_type:"s")
    end

    it "is_second_challenge?" do
      expect(@picture_thread.is_second_challenge?).to be(true)
      expect(@picture_thread.is_minute_challenge?).to be(false)
      expect(@picture_thread.is_hour_challenge?).to be(false)
    end

    it "closes 60 seconds from creation" do
      expect(@picture_thread.closing_date).to eq(@picture_thread.created_at + 60.seconds)
    end

  end

  context "60 minutes challenge" do

    before(:each) do
      @picture_thread = FactoryGirl.create(:picture_thread, lasting_time_type:"m")
    end

    it "is_second_challenge?" do
      expect(@picture_thread.is_second_challenge?).to be(false)
      expect(@picture_thread.is_minute_challenge?).to be(true)
      expect(@picture_thread.is_hour_challenge?).to be(false)
    end

    it "closes 60 seconds from creation" do
      expect(@picture_thread.closing_date).to eq(@picture_thread.created_at + 60.minutes)
    end

  end

  context "60 hours challenge" do

    before(:each) do
      @picture_thread = FactoryGirl.create(:picture_thread, lasting_time_type:"h")
    end
  
    it "is_second_challenge?" do
      expect(@picture_thread.is_second_challenge?).to be(false)
      expect(@picture_thread.is_minute_challenge?).to be(false)
      expect(@picture_thread.is_hour_challenge?).to be(true)
    end

    it "closes 60 seconds from creation" do
      expect(@picture_thread.closing_date).to eq(@picture_thread.created_at + 60.hours)
    end

  end

  context "creating new challenge" do

    it "notifies users" do
      device1 = FactoryGirl.create(:device)
      device2 = FactoryGirl.create(:device)
      picture_thread = FactoryGirl.build(:picture_thread)
      expect(PushNotification).to receive(:notify_message_to_devices).with("Vite ! Une minute pour répondre au défi de #{picture_thread.author.display_name} : #{picture_thread.title} !", [device1, device2])
      picture_thread.save
    end

  end

end
