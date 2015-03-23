require 'rails_helper'

RSpec.describe User do

  context ".display_name" do
    it "should display first name" do
      user = FactoryGirl.create(:user)
      expect(user.display_name).to eq(user.facebook_name)
    end
  end
end