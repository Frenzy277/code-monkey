require 'spec_helper'

describe QueueItemsController do

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob)   { Fabricate(:user) }
    let(:mentor_skill) { Fabricate(:skill, mentor: bob) }
    before { set_current_user(alice) }

    it "redirects to dashboard url" do
      post :create, Fabricate.attributes_for(:queue_item, skill: mentor_skill)
      expect(response).to redirect_to dashboard_url
    end
    
    it "creates the queue_item under mentor" do
      post :create, Fabricate.attributes_for(:queue_item, skill: mentor_skill)
      expect(QueueItem.first.mentor).to eq(bob)
    end
    
    it "creates the queue_item under mentee" do
      post :create, Fabricate.attributes_for(:queue_item)
      expect(QueueItem.first.mentee).to eq(alice)
    end

    it "creates the queue_item for right support" do
      post :create, Fabricate.attributes_for(:queue_item, skill: mentor_skill)
      expect(QueueItem.count).to eq(1)
    end

    it "does not create the queue_item for invalid support" do
      post :create, Fabricate.attributes_for(:queue_item, skill: mentor_skill, support: "no match")
      expect(QueueItem.count).to eq(0)
    end    

    it "does not create the queue_item for different user" do
      doug = Fabricate(:user)

      post :create, Fabricate.attributes_for(:queue_item, skill: mentor_skill, user: doug)
      expect(doug.queue_items.count).to eq(0)
    end

    it "redirects to root_url for unauthorized users" do
      post :create, queue_item: Fabricate.attributes_for(:queue_item)
      expect(response).to redirect_to root_url
    end
    
  end
end