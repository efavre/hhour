require 'rails_helper'

RSpec.describe ChallengesController, type: :controller do

  describe "GET #index" do

    context "with valid token" do

      before(:each) do
        @user_authenticated = FactoryGirl.create(:user_authenticated)
        @request.headers["Authorization"] = "Token token=#{@user_authenticated.access_token}"    
      end

      context "without challenges" do

        it "returns 200" do
          get :index, format:"json"
          expect(response).to have_http_status(200)
        end

        it "assigns empty array" do
          get :index, format:"json"
          expect(assigns[:challenges]).to match_array([])
        end
      end

      context "with current user not invited to challenge" do

        context "with one challenge" do
          it "returns 200" do
            challenge = FactoryGirl.create(:challenge)
            get :index, format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns no item in array" do
            challenge = FactoryGirl.create(:challenge)
            get :index, format:"json"
            expect(assigns[:challenges]).to match_array([])
          end
        end

        context "with two challenges" do
          it "returns 200" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge2 = FactoryGirl.create(:challenge)
            get :index, format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns no items in array" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge2 = FactoryGirl.create(:challenge)
            get :index, format:"json"
            expect(assigns[:challenges]).to match_array([])
          end
        end

        context "with two challenges closing after param later_than" do
          it "returns 200" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge2 = FactoryGirl.create(:challenge)
            get :index, later_than:"197001010101", format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns no items in array" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge2 = FactoryGirl.create(:challenge)
            get :index, later_than:"197001010101", format:"json"
            expect(assigns[:challenges]).to match_array([])
          end      
        end

        context "with two challenges, one closing before param later_than" do
          it "returns 200" do
            challenge1 = FactoryGirl.create(:challenge, created_at:2.days.ago)
            challenge2 = FactoryGirl.create(:challenge)
            later_than = 1.day.ago.to_s(:number)
            get :index, later_than:later_than, format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns no items in array" do
            challenge1 = FactoryGirl.create(:challenge, created_at:2.days.ago)
            challenge2 = FactoryGirl.create(:challenge)
            later_than = 1.day.ago.to_s(:number)
            get :index, later_than:later_than, format:"json"
            expect(assigns[:challenges]).to match_array([])
          end
        end

      end

      context "with current user invited to challenge" do

       context "with two challenges" do
          it "returns 200" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge1.users << @user_authenticated
            challenge2 = FactoryGirl.create(:challenge)
            challenge2.users << @user_authenticated
            get :index, format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns two items in array" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge1.users << @user_authenticated
            challenge2 = FactoryGirl.create(:challenge)
            challenge2.users << @user_authenticated
            get :index, format:"json"
            expect(assigns[:challenges]).to match_array([challenge1, challenge2])
          end
        end

        context "with two challenges, one closing before param later_than" do
          it "returns 200" do
            challenge1 = FactoryGirl.create(:challenge, created_at:2.days.ago)
            challenge1.users << @user_authenticated
            challenge2 = FactoryGirl.create(:challenge)
            challenge2.users << @user_authenticated
            later_than = 1.day.ago.to_s(:number)
            get :index, later_than:later_than, format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns one items in array" do
            challenge1 = FactoryGirl.create(:challenge, created_at:2.days.ago)
            challenge1.users << @user_authenticated
            challenge2 = FactoryGirl.create(:challenge)
            challenge2.users << @user_authenticated
            later_than = 1.day.ago.to_s(:number)
            get :index, later_than:later_than, format:"json"
            expect(assigns[:challenges]).to match_array([challenge2])
          end
        end
      end


      context "with current user invited to only one challenge" do

       context "with two challenges" do
          it "returns 200" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge1.users << @user_authenticated
            challenge2 = FactoryGirl.create(:challenge)
            get :index, format:"json"
            expect(response).to have_http_status(200)
          end

          it "assigns no items in array" do
            challenge1 = FactoryGirl.create(:challenge)
            challenge1.users << @user_authenticated
            challenge2 = FactoryGirl.create(:challenge)
            get :index, format:"json"
            expect(assigns[:challenges]).to match_array([challenge1])
          end
        end
      end

    end

    context "without valid token" do
      context "without challenges" do

        it "returns 401" do
          get :index, format:"json"
          expect(response).to have_http_status(401)
        end

      end
    end

  end

  describe "POST #create" do
    before(:each) do
      @user_authenticated = FactoryGirl.create(:user_authenticated)
      @request.headers["Authorization"] = "Token token=#{@user_authenticated.access_token}"    
    end
    
    context "with no parameters" do
      it "returns 400" do
        post :create, format:"json"
        expect(response).to have_http_status(400)
      end

      it "returns missing params message" do
        post :create, format:"json"
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with challenge parameter" do
      it "returns 400" do
        post :create, challenge: {}, format:"json"
        expect(response).to have_http_status(400)
      end
      it "returns missing params message" do
        post :create, challenge: {}, format:"json"
        expect(response.body).to match(/missing parameters/)
      end      
    end

    context "with challenge parameters" do
      it "returns 201" do
        post :create, challenge: {title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        expect(response).to have_http_status(201)
      end
      it "creates challenge" do
        challenge_count = Challenge.count
        post :create, challenge: {title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        expect(Challenge.count).to eq(challenge_count + 1)
      end
    end

    context "with challenge and challengers parameters" do

      before(:each) do
        @challenger1 = FactoryGirl.create(:user_authenticated, facebook_id:"FACEBOOK_ID_CHALLENGER1")
        @challenger2 = FactoryGirl.create(:user_authenticated, facebook_id:"FACEBOOK_ID_CHALLENGER2")
      end

      it "returns 201" do
        post :create, challengers:[@challenger1.facebook_id, @challenger2.facebook_id], challenge: {title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        expect(response).to have_http_status(201)
      end
      
      it "creates challenge" do
        challenge_count = Challenge.count
        post :create, challengers:[@challenger1.facebook_id, @challenger2.facebook_id], challenge: {title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        expect(Challenge.count).to eq(challenge_count + 1)
      end

      it "adds author to challenged users" do
        post :create, challengers:[@challenger1.facebook_id, @challenger2.facebook_id], challenge: {title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        challenge = Challenge.last
        expect(challenge.users).to include(@user_authenticated)
      end

      it "invites challenged users" do
        post :create, challengers:[@challenger1.facebook_id, @challenger2.facebook_id], challenge: {title:"My Challenging Challenge", lasting_time:"m", picture:{file_key:"filekey123"}}, format:"json"
        challenge = Challenge.last
        expect(challenge.users).to match_array([@user_authenticated, @challenger1, @challenger2]) 
      end
      
    end

  end

  context "#check_params" do

    before(:each) do
      ChallengesController.send(:public, *ChallengesController.protected_instance_methods)  
    end
    
    context "with 1 existing param" do
      it "should return true" do
        provided_params = {key:"value"}
        expected_params = [:key]
        expect(@controller.check_params(provided_params, expected_params)).to be(true)
      end
    end

    context "with 1 unexisting param" do
      it "should return false" do
        provided_params = {key:"value"}
        expected_params = [:unexisting_key]
        expect(@controller.check_params(provided_params, expected_params)).to be(false)
      end
    end

    context "with 2 existing param" do
      it "should return true" do
        provided_params = {key1:"value", key2:"value"}
        expected_params = [:key1, :key2]
        expect(@controller.check_params(provided_params, expected_params)).to be(true)
      end
    end

    context "with 2 unexisting param" do
      it "should return false" do
        provided_params = {key1:"value", key2:"value"}
        expected_params = [:key, :unexisting_key]
        expect(@controller.check_params(provided_params, expected_params)).to be(false)
      end
    end

    context "with 3 existing params on 2 levels depth" do
      it "should return true" do
        provided_params = {key1:"value", key2:{key3:"value", key4:"value"}}
        expected_params = [:key1, {key2:[:key3, :key4]}]
        expect(@controller.check_params(provided_params, expected_params)).to be(true)
      end
    end

    context "with unexisting params on 2 levels depth" do
      it "should return false" do
        provided_params = {key1:"value", key2:{key3:"value", key4:"value"}}
        expected_params = [:key1, {key2:[:unexisting_key]}]
        expect(@controller.check_params(provided_params, expected_params)).to be(false)
      end
    end

    context "with 3 existing params on 3 levels depth" do
      it "should return true" do
        provided_params = {key1:"value", key2:{key3:{key5:"value", key6:"value"}, key7:"value"}}
        expected_params = [:key1, {key2:[{key3:[:key5,:key6]}]},:key7]
        expect(@controller.check_params(provided_params, expected_params)).to be(true)
      end
    end

    context "with unexisting params on 3 levels depth" do
      it "should return false" do
        provided_params = {key1:"value", key2:{key3:{key4:"value", key5:"value"}, key6:"value"}}
        expected_params = [:key1, {key2:[{key3:[:key4, :unexisting_key]}]}]
        expect(@controller.check_params(provided_params, expected_params)).to be(false)
      end
    end

  end

end
