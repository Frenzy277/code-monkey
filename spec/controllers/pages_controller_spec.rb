require 'spec_helper'

describe PagesController do
  
  describe "GET front" do    
    it "renders templates :front and no header layout" do
      get :front
      expect(response).to render_template "layouts/no_header"
      expect(response).to render_template :front
    end
  end
  
  describe "GET dashboard" do
    it "sets the @languages" do
      set_current_user
      html  = Fabricate(:language)
      css   = Fabricate(:language)
      rails = Fabricate(:language)
      get :dashboard
      expect(assigns(:languages)).to match_array([html, css, rails])
    end

    it "redirects unauthenticated users" do
      clear_current_user
      get :dashboard
      expect(response).to redirect_to root_url
    end
  end
end