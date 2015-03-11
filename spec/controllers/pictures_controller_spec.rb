require 'rails_helper'

RSpec.describe PicturesController, type: :controller do

  describe "GET #index" do

    context "without challenge" do
      it "returns 400 and empty array" do
        get :index, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

     context "with non existing challenge id" do
      it "returns 200 and one item in array" do
        get :index, challenge_id:1, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with existing empty challenge" do
      it "returns 200 and empty array" do
        challenge = FactoryGirl.create(:challenge)
        get :index, challenge_id:challenge.id, format:"json"
        expect(assigns[:challenge]).to eq(challenge)
        expect(assigns[:pictures]).to match_array([])
        expect(response).to have_http_status(200)
      end
    end

    context "with existing challenge" do
      it "returns 200 and empty pictures array" do
        challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
        get :index, challenge_id:challenge.id, format:"json"
        expect(assigns[:challenge]).to eq(challenge)
        expect(assigns[:pictures]).to match_array(challenge.reload.pictures)
        expect(response).to have_http_status(200)
      end
    end

    context "with existing challenge and later_than parameter" do
      it "returns 200 and empty pictures array" do
        challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
        challenge.reload
        challenge.pictures.first.update_attribute(:created_at, 2.days.ago)
        later_than = 1.day.ago.to_s(:number)

        get :index, challenge_id:challenge.id, later_than:later_than, format:"json"
        expect(assigns[:challenge]).to eq(challenge)
        expect(assigns[:pictures]).to match_array([challenge.pictures.last])
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "POST #create" do

    context "without challenge" do
      it "returns 400 and missing parameters message" do
        post :create, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with non existing challenge id" do
      it "returns 400 and missing parameters message" do
        get :index, challenge_id:1, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with existing challenge id but no picture params" do
      it "returns 400 and missing parameters message" do
        challenge = FactoryGirl.create(:challenge)
        post :create, challenge_id:challenge.id, format:"json"
        expect(response).to have_http_status(400)
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with existing challenge id picture params" do
      it "returns 201 and adds picture to challenge" do
        challenge = FactoryGirl.create(:challenge)
        pictures_count = challenge.reload.pictures.count
        post :create, challenge_id:challenge.id, picture:{author:"John", file_key:"filekey123AZE"},format:"json"
        expect(response).to have_http_status(201)
        expect(challenge.reload.pictures.count).to eq(pictures_count + 1)
      end
    end

  end

end
