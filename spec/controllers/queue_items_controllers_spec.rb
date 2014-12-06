require 'spec_helper'

describe QueueItemsController do

  describe "POST create" do
    it "redirects to root_url for unauthorized users" do
      html = Fabricate(:language)
      pds_to_html = Fabricate(:skill, language: html)
      post :create, queue_item: Fabricate(:queue_item, skill: pds_to_html)
      expect(response).to redirect_to root_url
    end

  end
end