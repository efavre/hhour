require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #create" do

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

    context "with user parameter and facebook_id" do
      it "returns 400" do
        post :create, user: {facebook_id:"myFacebookId"}, format:"json"
        expect(response).to have_http_status(400)
      end

      it "returns message missing parameters" do
        post :create, user: {facebook_id:"myFacebookId"}, format:"json"
        expect(response.body).to match(/missing parameters/)
      end      
    end

    context "with user parameter and first name" do
      it "returns 200" do
        post :create, user: {first_name:"John"}, format:"json"
        expect(response).to have_http_status(200)
      end

      it "returns user created message" do
        post :create, user: {first_name:"John"}, format:"json"
        expect(response.body).to match(/user created/)
      end

      it "creates user" do
        users_count = User.count
        post :create, user: {first_name:"John"}, format:"json"
        expect(User.count).to eq(users_count + 1)
      end
    end

    context "with user parameter and first name and facebook_id" do
      it "returns 200" do
        post :create, user: {first_name:"John", facebook_id:"myFacebookId"}, format:"json"
        expect(response).to have_http_status(200)
      end

      it "returns user created message" do
        post :create, user: {first_name:"John", facebook_id:"myFacebookId"}, format:"json"
        expect(response.body).to match(/user created/)
      end

      it "creates user" do
        users_count = User.count
        post :create, user: {first_name:"John", facebook_id:"myFacebookId"}, format:"json"
        expect(User.count).to eq(users_count + 1)
      end
    end

  end

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
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(assigns(:user)).to_not be(nil)
      end

      it "creates access token" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(assigns(:user).access_token).to_not be(nil)
      end

      it "renders 200" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(response).to have_http_status(200)
      end

      it "renders user authenticated message" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(true)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(response.body).to match(/user authenticated/)
      end

    end

    context "with invalid user" do

      it "authenticates user" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(false)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(assigns(:user)).to be(nil)
      end

      it "renders 200" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(false)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(response).to have_http_status(401)
      end

      it "renders user authenticated message" do
        allow(FacebookConnector).to receive(:check_access_token).and_return(false)
        post :authenticate, user:{facebook_id:"myFacebookId", facebook_token:"VALID_ACCESS_TOKEN"}, format:"json"
        expect(response.body).to match(/unauthorized/)
      end

    end

  end

end
