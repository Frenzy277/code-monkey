require 'spec_helper'

describe PagesController do
  
  describe "GET front" do    
    it "renders templates :front and no header layout" do
      get :front
      expect(response).to render_template "layouts/no_header"
      expect(response).to render_template :front
    end
  end
  
end