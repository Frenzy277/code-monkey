require 'spec_helper'

describe QueueItemsController do

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

      it "creates the queue_item" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(QueueItem.count).to eq(1)
      end
    
      it "creates the queue_item under mentor" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(QueueItem.first.mentor).to eq(bob)
      end
      
      it "creates the queue_item under mentee" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(QueueItem.first.mentee).to eq(alice)
      end

      it "sets flash success" do
        post :create, skill_id: mentor_skill.id, support: "mentoring"
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid params" do
      it "does not create the queue_item" do
        post :create, skill_id: mentor_skill.id, support: "no match"
        expect(QueueItem.count).to eq(0)
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