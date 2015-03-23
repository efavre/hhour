require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #authenticate" do 

    context "with invalid params" do

      it "returns 400" do
        post :authenticate, format:"json"
        expect(response).to have_http_status(400)
      end

      it "renders user authenticated message" do
        post :authenticate, format:"json"
        expect(response.body).to match(/missing parameters/)
      end

    end

    context "with valid user" do

      it "authenticates user" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN", facebook_name:"User Facebook"}, format:"json"
        expect(assigns(:user)).to_not be(nil)
      end

      it "creates access token" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN", facebook_name:"User Facebook"}, format:"json"
        expect(assigns(:user).access_token).to_not be(nil)
      end

      it "return 200" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN", facebook_name:"User Facebook"}, format:"json"
        expect(response).to have_http_status(200)
      end

      it "renders token" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN", facebook_name:"User Facebook"}, format:"json"
        user = assigns(:user)
        expect(response.body).to match(/\"token\":\"#{user.access_token}\"/)
      end

    end

    context "with invalid user" do

      it "authenticates user" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(false)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"INVALID_ACCESS_TOKEN", facebook_name:"User Facebook"}, format:"json"
        expect(assigns(:user)).to be(nil)
      end

      it "renders 200" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(false)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"INVALID_ACCESS_TOKEN", facebook_name:"User Facebook"}, format:"json"
        expect(response).to have_http_status(401)
      end

    end

  end

end
