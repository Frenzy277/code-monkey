require 'spec_helper'

describe QueueItemsController do

  describe "POST create" do
    


    it "redirects to root_url for unauthorized users" do
      post :create, queue_item: Fabricate.attributes_for(:queue_item)
      expect(response).to redirect_to root_url
    end

  end
end