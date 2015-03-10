require 'rails_helper'

RSpec.describe PictureThreadsController, type: :controller do

  describe "GET #index" do

    context "without challenges" do
      it "returns 200 and empty array" do
        get :index, format:"json"
        expect(assigns[:picture_threads]).to match_array([])
        expect(response).to have_http_status(200)
      end
    end

     context "with one challenge" do
      it "returns 200 and one item in array" do
        challenge = FactoryGirl.create(:picture_thread)
        get :index, format:"json"
        expect(assigns[:picture_threads]).to match_array([challenge])
        expect(response).to have_http_status(200)
      end
    end

    context "with two challenges" do
      it "returns 200 and two items in array" do
        challenge1 = FactoryGirl.create(:picture_thread)
        challenge2 = FactoryGirl.create(:picture_thread)
        get :index, format:"json"
        expect(assigns[:picture_threads]).to match_array([challenge1, challenge2])
        expect(response).to have_http_status(200)
      end
    end

    context "with two challenges closing after param later_than" do
      it "returns 200 and two items in array" do
        challenge1 = FactoryGirl.create(:picture_thread)
        challenge2 = FactoryGirl.create(:picture_thread)
        get :index, later_than:"197001010101", format:"json"
        expect(assigns[:picture_threads]).to match_array([challenge1, challenge2])
        expect(response).to have_http_status(200)
      end
    end

    context "with two challenges closing before param later_than" do
      it "returns 200 and two items in array" do
        challenge1 = FactoryGirl.create(:picture_thread, created_at:2.days.ago)
        challenge2 = FactoryGirl.create(:picture_thread)
        later_than = 1.day.ago.to_s(:number)
        get :index, later_than:later_than, format:"json"
        expect(assigns[:picture_threads]).to match_array([challenge2])
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "POST #create" do

    # context "with no parameters" do
    #   it "returns 400" do
    #     post :create
    #     expect(response).to have_http_status(400)
    #     expect(response.body).to match(/missing parameters/)
    #   end
    # end

    # context "with user parameter" do
    #   it "returns 400" do
    #     post :create, user: {}
    #     expect(response).to have_http_status(400)
    #     expect(response.body).to match(/missing parameters/)
    #   end
    # end

    # context "with user parameter and facebook_id" do
    #   it "returns 400" do
    #     post :create, user: {facebook_id:"myFacebookId"}, format:"json"
    #     expect(response).to have_http_status(400)
    #     expect(response.body).to match(/missing parameters/)
    #   end
    # end

    # context "with user parameter and first name" do
    #   it "returns user" do
    #     post :create, user: {first_name:"John"}, format:"json"
    #     expect(response).to have_http_status(200)
    #     expect(response.body).to match(/user created/)
    #   end
    # end

    # context "with user parameter and first name and facebook_id" do
    #   it "returns user" do
    #     post :create, user: {first_name:"John", facebook_id:"myFacebookId"}, format:"json"
    #     expect(response).to have_http_status(200)
    #     expect(response.body).to match(/user created/)
    #   end
    # end

  end

end
