require 'rails_helper'

RSpec.describe DevicesController, type: :controller do

  describe "POST #create" do

    context "without valid token" do
      context "without challenges" do

        it "returns 401" do
          post :create, format:"json"
          expect(response).to have_http_status(401)
        end

      end
    end

    context "with valid token" do

      before(:each) do
        @user_authenticated = FactoryGirl.create(:user_authenticated)
        @request.headers["Authorization"] = "Token token=#{@user_authenticated.access_token}"    
      end

      context "with html format" do
        it "returns 406" do
          post :create, format:"html"
          expect(response).to have_http_status(406)
        end

        it "returns message format not acceptable" do
          post :create, format:"html"
          expect(response.body).to match(/format not acceptable/)
        end
      end

      context "with no parameters" do
        it "returns 400" do
          post :create, format:"json"
          expect(response).to have_http_status(400)
        end

        it "returns message missing parameters" do
          post :create, format:"json"
          expect(response.body).to match(/missing parameters/)
        end
      end

      context "with user parameter" do
        it "returns 400" do
          post :create, user: {}, format:"json"
          expect(response).to have_http_status(400)
        end

        it "returns message missing parameters" do
          post :create, user: {}, format:"json"
          expect(response.body).to match(/missing parameters/)
        end      
      end


      context "with user parameter and token" do
        it "returns 200" do
          post :create, user: {device_token:"DEVICE_TOKEN"}, format:"json"
          expect(response).to have_http_status(200)
        end

        it "creates device" do
          devices_count = @user_authenticated.devices.count
          post :create, user: {device_token:"UNIQUE_DEVICE_TOKEN"}, format:"json"
          expect(@user_authenticated.devices.reload.count).to eq(devices_count + 1)
        end
      end
    end
  end
end
