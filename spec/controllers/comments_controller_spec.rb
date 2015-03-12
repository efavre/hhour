require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "GET #index" do

    context "with unexisting picture id" do
      it "returns 400" do
        get :index, picture_id:1,format:"json"
        expect(response).to have_http_status(400)
      end

      it "returns message missing parameters" do
        get :index, picture_id:1,format:"json"
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with existing picture id" do
      it "returns 200" do
        picture = FactoryGirl.create(:picture)
        get :index, picture_id:picture.id, format:"json"
        expect(response).to have_http_status(200)
      end
      
      it "assigns picture" do
        picture = FactoryGirl.create(:picture)
        get :index, picture_id:picture.id, format:"json"
        expect(assigns[:picture]).to eq(picture)
      end
    end

  end

  describe "POST #create" do

    context "with unexisting picture id" do
      it "returns 400" do
        get :index, picture_id:1, format:"json"
        expect(response).to have_http_status(400)
      end

      it "returns message missing parameters" do
        get :index, picture_id:1, format:"json"
        expect(response.body).to match(/missing parameters/)
      end
    end

    context "with comment parameters" do
      it "returns 200" do
        picture = FactoryGirl.create(:picture)
        post :create, picture_id:picture.id, comment: {user:"John",title:"a comment", content:"the content of my comment"}, format:"json"
        expect(response).to have_http_status(200)
      end
      
      it "assigns picture" do
        picture = FactoryGirl.create(:picture)
        post :create, picture_id:picture.id, comment: {user:"John",title:"My Challenging Challenge", content:"m"}, format:"json"
        expect(assigns[:picture]).to eq(picture)
      end 

      it "creates comment" do 
        picture = FactoryGirl.create(:picture)
        comments_count = picture.comments.count
        post :create, picture_id:picture.id, comment: {user:"John",title:"My Challenging Challenge", content:"m"}, format:"json"
        expect(picture.reload.comments.count).to eq(comments_count + 1)
      end
    end

  end

end
