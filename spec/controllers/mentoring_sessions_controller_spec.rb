require 'spec_helper'

describe MentoringSessionsController do

  describe "GET index" do    
    it "sets the @mentoring_sessions" do
      bob = Fabricate(:user)
      set_current_user(bob)
      alice = Fabricate(:user)
      doug = Fabricate(:user)
      bob_skill = Fabricate(:skill, mentor: bob)
      ms1 = Fabricate(:mentoring_session,
                       skill: bob_skill,
                       mentor: bob,
                       mentee: doug)
      ms2 = Fabricate(:mentoring_session,
                       skill: bob_skill,
                       mentor: bob,
                       mentee: alice)
      get :index
      expect(assigns(:mentoring_sessions)).to match_array([ms1, ms2])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:alice)        { Fabricate(:user) }
    let(:bob)          { Fabricate(:user) }
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
        should set_the_flash[:success]
      end

      it "sets position for multiple uncomplete mentoring sessions" do
        Fabricate.times(2, :mentoring_session, mentor: bob, status: "completed", position: nil)
        Fabricate(:mentoring_session, mentor: bob, status: "accepted")
        Fabricate(:mentoring_session, mentor: bob, status: "completed", position: nil)
        Fabricate(:mentoring_session, mentor: bob, status: "rejected")
        html_skill = Fabricate(:skill, mentor: bob)
        post :create, skill_id: html_skill.id, support: "mentoring"
        
        html_mentoring_session = MentoringSession.where(skill: html_skill, mentee: alice).first
        expect(html_mentoring_session.position).to eq(3)
      end
    end

    context "with invalid params" do
      it "does not create the mentoring_session" do
        post :create, skill_id: mentor_skill.id, support: "no match"
        expect(MentoringSession.count).to eq(0)
      end

      it "does not create the mentoring session for mentor self" do
        clear_current_user
        set_current_user(bob)
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(MentoringSession.count).to eq(0)
      end

      it "sets flash danger" do
        post :create, skill_id: mentor_skill.id, support: "no match"
        should set_the_flash.now[:danger]
      end
    end

    it_behaves_like "require sign in" do
      let(:action) do
        post :create, skill_id: mentor_skill.id, support: "no match"
      end
    end
  end

  describe "PATCH update_sessions" do
    let(:bob) { Fabricate(:user) }
    before { set_current_user(bob) }

    context "with valid data" do
      let(:ms1) { Fabricate(:mentoring_session, mentor: bob, position: 1) }
      let(:ms2) { Fabricate(:mentoring_session, mentor: bob, position: 2) }

      it "redirects to mentoring sessions url" do
        patch :update_sessions, mentoring_sessions: [
            {id: ms1.id, position: 1, status: "pending"},
            {id: ms2.id, position: 2, status: "pending"}]
        should redirect_to mentoring_sessions_url
      end

      context "positions" do
        it "updates the positions for mentoring sessions" do
          patch :update_sessions, mentoring_sessions: [
            {id: ms1.id, position: 2, status: "pending"},
            {id: ms2.id, position: 1, status: "pending"}]
          expect(bob.mentor_sessions).to eq([ms2, ms1])
        end

        it "normalizes the positions for non-completed status" do
          patch :update_sessions, mentoring_sessions: [
            {id: ms1.id, position: 3, status: "pending"},
            {id: ms2.id, position: 2, status: "pending"}]
          expect(bob.mentor_sessions.map(&:position)).to eq([1, 2])
        end

        it "normalizes the positions for mixed statuses" do
          patch :update_sessions, mentoring_sessions: [
            {id: ms1.id, position: 3, status: "pending"},
            {id: ms2.id, position: 2, status: "completed"}]
          expect(bob.mentor_sessions.map(&:position)).to eq([1, nil])
        end
      end

      context "status" do
        it "updates the statuses for mentoring sessions" do
          ms = Fabricate(:mentoring_session, mentor: bob, status: "pending")
          patch :update_sessions, mentoring_sessions: [
            {id: ms.id, position: 1, status: "accepted"}]
          expect(MentoringSession.first.status).to eq("accepted")
        end
      end

      context "balance on status completed" do
        it "updates +1 balance for mentor when status is completed" do
          ms = Fabricate(:mentoring_session, mentor: bob, status: "accepted")
          patch :update_sessions, mentoring_sessions: [
            {id: ms.id, position: 1, status: "completed"}]
          expect(bob.reload.balance).to eq(2)
        end

        it "updates -1 balance for mentee when status is completed" do
          alice = Fabricate(:user)
          ms = Fabricate(:mentoring_session, mentee: alice, mentor: bob, status: "accepted")
          patch :update_sessions, mentoring_sessions: [
            {id: ms.id, position: 1, status: "completed"}]
          expect(alice.reload.balance).to eq(0)
        end
      end

      context "code helped projects on status completed" do
        it "updates +1 helped_total for mentor when status is completed" do
          ms = Fabricate(:mentoring_session, mentor: bob, status: "accepted")
          patch :update_sessions, mentoring_sessions: [
            {id: ms.id, position: 1, status: "completed"}]
          expect(Skill.first.helped_total).to eq(1)
        end
      end
    end

    context "with invalid data" do
      let(:ms1) { Fabricate(:mentoring_session, mentor: bob, position: 1) }
      let(:ms2) { Fabricate(:mentoring_session, mentor: bob, position: 2) }
      
      it "redirects to mentoring sessions url if params are missing" do
        patch :update_sessions
        should redirect_to mentoring_sessions_url
      end

      it "redirects to mentoring sessions url" do
        patch :update_sessions, mentoring_sessions: [
          {id: ms1.id, position: 3.2, status: "pending"},
          {id: ms2.id, position: 2, status: "pending"}]
        should redirect_to mentoring_sessions_url
      end

      it "sets flash danger" do
        patch :update_sessions, mentoring_sessions: [
          {id: ms1.id, position: 3.5, status: "pending"},
          {id: ms2.id, position: 2, status: "pending"}]
        expect(flash[:danger]).to be_present
      end

      it "does not update mentoring session for any other user" do
        alice = Fabricate(:user)
        ms = Fabricate(:mentoring_session, mentor: alice, status: "pending")
        patch :update_sessions, mentoring_sessions: [{id: ms.id, position: 1, status: "accepted"}]
        expect(MentoringSession.first.status).to eq("pending")
      end

      context "position" do
        it "does not update any mentoring session unless position is not integer" do
          ms1 = Fabricate(:mentoring_session, mentor: bob, position: 1)
          ms2 = Fabricate(:mentoring_session, mentor: bob, position: 2)
          patch :update_sessions, mentoring_sessions: [{id: ms1.id, position: 3, status: "accepted"}, {id: ms2.id, position: 2.2, status: "accepted"}]
          expect(ms1.reload.position).to eq(1)
        end
      end

      context "status" do
        let(:mentoring_session) do
          Fabricate(:mentoring_session, mentor: bob, status: "pending")
        end
        
        it "does not update different than allowed status" do          
          patch :update_sessions, mentoring_sessions: [{id: mentoring_session.id, position: 3, status: "xxx"}]
          expect(mentoring_session.reload.status).to eq("pending")
        end

        it "sets flash danger" do
          patch :update_sessions, mentoring_sessions: [{id: mentoring_session.id, position: 3, status: "xxx"}]
          should set_the_flash[:danger]
        end
      end

      context "balance on status completed" do
        it "does not update +1 balance for mentor" do
          ms = Fabricate(:mentoring_session, mentor: bob, status: "completed", position: nil)
          patch :update_sessions, mentoring_sessions: [{id: ms.id, position: 1, status: "completed"}]
          expect(bob.reload.balance).to eq(1)
        end

        it "does not update -1 balance for mentee" do
          alice = Fabricate(:user)
          ms = Fabricate(:mentoring_session, mentee: alice, mentor: bob, status: "completed", position: nil)
          patch :update_sessions, mentoring_sessions: [{id: ms.id, position: 1, status: "completed"}]
          expect(alice.reload.balance).to eq(1)
        end
      end

      context "code helped projects update on status completed" do
        it "does not update +1 helped_total for mentor" do
          ms = Fabricate(:mentoring_session, mentor: bob, status: "completed", position: nil)
          patch :update_sessions, mentoring_sessions: [{id: ms.id, position: 1, status: "completed"}]
          expect(Skill.first.helped_total).to eq(0)
        end
      end
    end

    it_behaves_like "require sign in" do
      let(:action) do
        ms = Fabricate(:mentoring_session)
        patch :update_sessions, mentoring_sessions: [{id: ms.id, position: 1, status: "accepted"}]
      end
    end
  end
end