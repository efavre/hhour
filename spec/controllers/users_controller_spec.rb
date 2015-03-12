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

end
