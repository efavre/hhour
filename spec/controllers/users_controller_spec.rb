require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #create" do

    context "with no parameters" do
      it "returns 400" do
        post :create
        expect(response).to have_http_status(400)
      end
    end

    context "with user parameter" do
      it "returns to new session path" do
        post :create, user: {}

        expect(response).to have_http_status(400)
      end
    end

    # context "without access tokens" do
    #   it "redirects to new session path" do

    #     get :index
        
    #     expect(response).to have_http_status(302)
    #     expect(response).to redirect_to(new_session_path)
    #   end
    # end

  end

end
