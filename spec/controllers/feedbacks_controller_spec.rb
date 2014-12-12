require 'spec_helper'

describe FeedbacksController do
  let(:alice) { Fabricate(:user) }
  before { set_current_user(alice) }

  describe "GET index" do # AJAX only
    let!(:rails) { Fabricate(:skill) }

    it "sets the @skill" do
      xhr :get, :index, skill_id: rails.id
      expect(assigns(:skill)).to eq(rails)
    end

    it "sets the @feedbacks" do
      testing = Fabricate(:mentoring_session, skill: rails)
      rendering = Fabricate(:mentoring_session, skill: rails)
      feedback_tests = Fabricate(:feedback, mentoring_session: testing)
      feedback_renders = Fabricate(:feedback, mentoring_session: rendering)
      xhr :get, :index, skill_id: rails.id
      expect(assigns(:feedbacks)).to eq([feedback_renders, feedback_tests])
    end

    it_behaves_like "require sign in" do
      let(:action) { xhr :get, :index, skill_id: rails.id }
    end
  end

  describe "GET new" do
    let!(:ms) { Fabricate(:mentoring_session, mentee: alice) }

    context "AJAX request" do
      it "sets the @mentoring_session" do        
        xhr :get, :new, mentoring_session_id: ms.id
        expect(assigns(:mentoring_session)).to eq(ms)
      end

      it "sets the @feedback" do        
        xhr :get, :new, mentoring_session_id: ms.id
        expect(assigns(:feedback)).to be_instance_of(Feedback)
      end

      it_behaves_like "require sign in" do
        let(:action) { xhr :get, :new, mentoring_session_id: ms.id }
      end
    end

    context "HTML request" do
      it "sets the @mentoring_session" do 
        get :new, mentoring_session_id: ms.id
        expect(assigns(:mentoring_session)).to eq(ms)
      end

      it "sets the @feedback" do        
        get :new, mentoring_session_id: ms.id
        expect(assigns(:feedback)).to be_instance_of(Feedback)
      end

      it_behaves_like "require sign in" do
        let(:action) { get :new, mentoring_session_id: ms.id }
      end
    end  
  end

  describe "POST create" do
    let!(:ms) { Fabricate(:mentoring_session, mentee: alice) }

    context "AJAX request" do
      context "with valid data" do
        it "creates feedback" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          expect(Feedback.count).to eq(1)
        end

        it "creates feedback under mentoring session" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          expect(Feedback.first.mentoring_session).to eq(ms)
        end

        it "creates feedback under mentee" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          expect(Feedback.first.giver).to eq(alice)
        end

        it "sets the @mentoring_session" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          expect(assigns(:mentoring_session)).to eq(ms)
        end

        it "does not set the flash danger" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          expect(flash[:danger]).to be nil
        end
      end

      context "with invalid data" do
        it "does not create the feedback" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "", recommended: "1" }
          expect(Feedback.count).to eq(0)
        end

        it "sets flash danger" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "", recommended: "1" }
          expect(flash[:danger]).to be_present
        end

        it "sets the @feedback" do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "", recommended: "1" }
          expect(assigns[:feedback]).to be_instance_of(Feedback)
        end
      end

      it_behaves_like "require sign in" do
        let(:action) do
          xhr :post, :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
        end
      end
    end

    context "HTML request" do
      context "with valid data" do
        it "redirects to dashboard url" do
          post :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          should redirect_to dashboard_url
        end

        it "sets flash success" do
          post :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
          should set_the_flash[:success]
        end
      end

      context "with invalid data" do
        it "sets the @feedback" do
          post :create, mentoring_session_id: ms.id, feedback: { content: "", recommended: "1" }
          expect(assigns[:feedback]).to be_instance_of(Feedback)
        end

        it "renders the new template" do
          post :create, mentoring_session_id: ms.id, feedback: { content: "", recommended: "1" }
          expect(response).to render_template :new
        end
      end

      it_behaves_like "require sign in" do
        let(:action) do
          post :create, mentoring_session_id: ms.id, feedback: { content: "Awesome", recommended: "1" }
        end
      end
    end
  end
end