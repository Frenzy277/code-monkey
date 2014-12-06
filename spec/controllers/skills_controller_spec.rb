require 'spec_helper'

describe SkillsController do

  describe "GET new" do

    it "for unauthorized users" do
      get :new
      expect(response).to redirect_to root_url
    end
  end

end