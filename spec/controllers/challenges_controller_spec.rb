require 'rails_helper'

RSpec.describe ChallengesController, type: :controller do

  describe "GET #index" do

    context "without challenges" do
      it "returns 200 and empty array" do
        get :index, format:"json"
        expect(assigns[:challenges]).to match_array([])
        expect(response).to have_http_status(200)
      end
    end

     context "with one challenge" do
      it "returns 200 and one item in array" do
        challenge = FactoryGirl.create(:challenge)
        get :index, format:"json"
        expect(assigns[:challenges]).to match_array([challenge])
        expect(response).to have_http_status(200)
      end
    end

    context "with two challenges" do
      it "returns 200 and two items in array" do
        challenge1 = FactoryGirl.create(:challenge)
        challenge2 = FactoryGirl.create(:challenge)
        get :index, format:"json"
        expect(assigns[:challenges]).to match_array([challenge1, challenge2])
        expect(response).to have_http_status(200)
      end
    end

    context "with two challenges closing after param later_than" do
      it "returns 200 and two items in array" do
        challenge1 = FactoryGirl.create(:challenge)
        challenge2 = FactoryGirl.create(:challenge)
        get :index, later_than:"197001010101", format:"json"
        expect(assigns[:challenges]).to match_array([challenge1, challenge2])
        expect(response).to have_http_status(200)
      end
    end

    context "with two challenges closing before param later_than" do
      it "returns 200 and two items in array" do
        challenge1 = FactoryGirl.create(:challenge, created_at:2.days.ago)
        challenge2 = FactoryGirl.create(:challenge)
        later_than = 1.day.ago.to_s(:number)
        get :index, later_than:later_than, format:"json"
        expect(assigns[:challenges]).to match_array([challenge2])
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "POST #create" do

    context "with no parameters" do
      it "returns 400" do
        post :create, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with challenge parameter" do
      it "returns 400" do
        post :create, challenge: {}, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with challenge full parameters" do
      it "creates challenge" do
        challenge_count = Challenge.count
        post :create, challenge: {author:"John",title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        expect(Challenge.count).to eq(challenge_count + 1)
      end
    end

    context "with challenge full parameters" do
      it "returns 200" do
        post :create, challenge: {author:"John",title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        expect(response).to have_http_status(201)
      end
    end

  end

end
