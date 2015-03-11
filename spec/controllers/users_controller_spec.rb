require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #create" do

    context "with html format" do
      it "returns 400" do
        post :create, format:"html"
        expect(response).to have_http_status(406)
        expect(response.body).to match(/format not acceptable/)
      end
    end

    context "with no parameters" do
      it "returns 400" do
        post :create, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with user parameter" do
      it "returns 400" do
        post :create, user: {}, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with user parameter and facebook_id" do
      it "returns 400" do
        post :create, user: {facebook_id:"myFacebookId"}, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with user parameter and first name" do
      it "returns user" do
        post :create, user: {first_name:"John"}, format:"json"
        expect(response).to have_http_status(200)
        expect(response.body).to match(/user created/)
      end
    end

    context "with user parameter and first name and facebook_id" do
      it "returns user" do
        post :create, user: {first_name:"John", facebook_id:"myFacebookId"}, format:"json"
        expect(response).to have_http_status(200)
        expect(response.body).to match(/user created/)
      end
    end

  end

end
