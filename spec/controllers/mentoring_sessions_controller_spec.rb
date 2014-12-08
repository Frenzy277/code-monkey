require 'spec_helper'

describe MentoringSessionsController do

  describe "GET index" do
    let!(:bob) { Fabricate(:user) }
    before { set_current_user(bob) }
    
    it "sets the @mentoring_sessions" do
      alice = Fabricate(:user)
      doug = Fabricate(:user)
      bob_skill = Fabricate(:skill, mentor: bob)
      qi1 = Fabricate(:mentoring_session, skill: bob_skill, mentor: bob, mentee: doug)
      qi2 = Fabricate(:mentoring_session, skill: bob_skill, mentor: bob, mentee: alice)
      get :index
      expect(assigns(:mentoring_sessions)).to match_array([qi1, qi2])
    end

    it "redirects to root_url for unauthorized users" do
      clear_current_user
      get :index
      expect(response).to redirect_to root_url
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob)   { Fabricate(:user) }
    let(:mentor_skill) { Fabricate(:skill, mentor: bob) }
    before { set_current_user(alice) }

    context "with valid params" do
      it "redirects to dashboard url" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(response).to redirect_to dashboard_url
      end

      it "creates the mentoring_session" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(MentoringSession.count).to eq(1)
      end
    
      it "creates the mentoring_session under mentor" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(MentoringSession.first.mentor).to eq(bob)
      end
      
      it "creates the mentoring_session under mentee" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(MentoringSession.first.mentee).to eq(alice)
      end

      it "sets flash success" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(flash[:success]).to be_present
      end

      it "sets correct position for multiple mentoring_sessions" do
        Fabricate(:mentoring_session, skill: mentor_skill, mentor: bob, mentee: alice)
        html_skill = Fabricate(:skill, mentor: bob)
        post :create, skill_id: html_skill.id, support: "mentoring"
        
        html_mentoring_session = MentoringSession.where(skill: html_skill, mentee: alice).first
        expect(html_mentoring_session.position).to eq(2)
      end
    end

    context "with invalid params" do
      it "does not create the mentoring_session" do
        post :create, skill_id: mentor_skill.id, support: "no match"
        expect(MentoringSession.count).to eq(0)
      end    

      it "sets flash danger" do
        post :create, skill_id: mentor_skill.id, support: "no match"
        expect(flash[:danger]).to be_present
      end
    end

    it "redirects to root_url for unauthorized users" do
      clear_current_user
      post :create, skill_id: mentor_skill.id, support: "no match"
      expect(response).to redirect_to root_url
    end
   
  end
end