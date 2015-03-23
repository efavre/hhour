require 'rails_helper'

RSpec.describe PicturesController, type: :controller do


  
  describe "GET #index" do

    context "without valid token" do
      context "without challenges" do

        it "returns 401" do
          get :index, format:"json"
          expect(response).to have_http_status(401)
        end

      end
    end

    context "with valid token" do

      before(:each) do
        user_authenticated = FactoryGirl.create(:user_authenticated)
        @request.headers["Authorization"] = "Token token=#{user_authenticated.access_token}"    
      end

      context "without challenge" do
        it "returns 400" do
          get :index, format:"json"
          expect(response).to have_http_status(400)
        end

        it "assigns empty array" do
          get :index, format:"json"
          expect(response.body).to match(/missing parameters/)
        end
      end

       context "with non existing challenge id" do
        it "returns 400" do
          get :index, challenge_id:1, format:"json"
          expect(response).to have_http_status(400)
        end

        it "assigns one item in array" do
          get :index, challenge_id:1, format:"json"
          expect(response.body).to match(/missing parameters/)
        end
      end

      context "with existing empty challenge" do
        it "returns 200" do
          challenge = FactoryGirl.create(:challenge)
          get :index, challenge_id:challenge.id, format:"json"
          expect(response).to have_http_status(200)
        end

        it "assigns empty array for pictures" do
          challenge = FactoryGirl.create(:challenge)
          get :index, challenge_id:challenge.id, format:"json"
          expect(assigns[:pictures]).to match_array([])
        end
        
        it "assigns existing challenge" do
          challenge = FactoryGirl.create(:challenge)
          get :index, challenge_id:challenge.id, format:"json"
          expect(assigns[:challenge]).to eq(challenge)
        end
      end

      context "with existing challenge" do
        it "returns 200" do
          challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
          get :index, challenge_id:challenge.id, format:"json"
          expect(response).to have_http_status(200)
        end

        it "assigns 2 pictures array" do
          challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
          get :index, challenge_id:challenge.id, format:"json"
          expect(assigns[:pictures]).to match_array(challenge.reload.pictures)
        end

        it "assigns challenge" do
          challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
          get :index, challenge_id:challenge.id, format:"json"
          expect(assigns[:challenge]).to eq(challenge)
        end
      end

      context "with existing challenge and later_than parameter" do
        it "returns 200" do
          challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
          challenge.reload
          challenge.pictures.first.update_attribute(:created_at, 2.days.ago)
          later_than = 1.day.ago.to_s(:number)
          get :index, challenge_id:challenge.id, later_than:later_than, format:"json"
          expect(response).to have_http_status(200)
        end

        it "assigns 1 picture array" do
          challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
          challenge.reload
          challenge.pictures.first.update_attribute(:created_at, 2.days.ago)
          later_than = 1.day.ago.to_s(:number)
          get :index, challenge_id:challenge.id, later_than:later_than, format:"json"
          expect(assigns[:pictures]).to match_array([challenge.pictures.last])
        end

        it "assigns existing challenge" do
          challenge = FactoryGirl.create(:challenge_with_pictures, pictures_count: 2)
          challenge.reload
          challenge.pictures.first.update_attribute(:created_at, 2.days.ago)
          later_than = 1.day.ago.to_s(:number)
          get :index, challenge_id:challenge.id, later_than:later_than, format:"json"
          expect(assigns[:challenge]).to eq(challenge)
        end

      end

    end

  end

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
        user_authenticated = FactoryGirl.create(:user_authenticated)
        @request.headers["Authorization"] = "Token token=#{user_authenticated.access_token}"    
      end

      context "without challenge" do
        it "returns 400" do
          post :create, format:"json"
          expect(response).to have_http_status(400)
        end

        it "returns missing parameters message" do
          post :create, format:"json"
          expect(response.body).to match(/missing parameters/)
        end      
      end

      context "with non existing challenge id" do
        it "returns 400" do
          get :index, challenge_id:1, format:"json"
          expect(response).to have_http_status(400)
        end

        it "returns missing parameters message" do
          get :index, challenge_id:1, format:"json"
          expect(response.body).to match(/missing parameters/)
        end      
      end

      context "with existing challenge id but no picture params" do
        it "returns 400" do
          challenge = FactoryGirl.create(:challenge)
          post :create, challenge_id:challenge.id, format:"json"
          expect(response).to have_http_status(400)
        end

        it "returns missing parameters message" do
          challenge = FactoryGirl.create(:challenge)
          post :create, challenge_id:challenge.id, format:"json"
          expect(response.body).to match(/missing parameters/)
        end
      end

      context "with existing challenge id picture params" do
        it "returns 201" do
          challenge = FactoryGirl.create(:challenge)
          pictures_count = challenge.reload.pictures.count
          post :create, challenge_id:challenge.id, picture:{author:"John", file_key:"filekey123AZE"},format:"json"
          expect(response).to have_http_status(201)
        end

        it "adds picture to challenge" do
          challenge = FactoryGirl.create(:challenge)
          pictures_count = challenge.reload.pictures.count
          post :create, challenge_id:challenge.id, picture:{author:"John", file_key:"filekey123AZE"},format:"json"
          expect(challenge.reload.pictures.count).to eq(pictures_count + 1)
        end
      end
    end
  end

end
