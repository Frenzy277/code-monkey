require 'spec_helper'

describe FeedbacksController do
  let(:alice) { Fabricate(:user) }
  before { set_current_user(alice) }
  let!(:ms) { Fabricate(:mentoring_session, mentee: alice) }

  describe "GET new" do

    context "AJAX request" do
      it "sets the @mentoring_session" do        
        xhr :get, :new, mentoring_session_id: ms.id
        expect(assigns(:mentoring_session)).to eq(ms)
      end

      it "redirects to root url for unauthorized" do
        clear_current_user
        xhr :get, :new, mentoring_session_id: ms.id
        expect(response).to redirect_to root_url
      end
    end

    context "HTML request" do
      it "sets the @mentoring_session" do 
        get :new, mentoring_session_id: ms.id
        expect(assigns(:mentoring_session)).to eq(ms)
      end

      it "redirects to root url for unauthorized" do
        clear_current_user
        get :new, mentoring_session_id: ms.id
        expect(response).to redirect_to root_url
      end
    end
  
  end
end