require 'spec_helper'

describe LanguagesController do
  describe "GET index" do
    it "sets the @languages" do
      set_current_user
      html  = Fabricate(:language)
      css   = Fabricate(:language)
      rails = Fabricate(:language)
      get :index
      expect(assigns(:languages)).to match_array([html, css, rails])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }      
    end
  end

  describe "GET show" do
    it "sets the @language" do
      language = Fabricate(:language)
      get :show, id: language.id
      expect(assigns(:language)).to eq(language)
    end
  end

  describe "GET front" do
    it "sets the @languages" do
      html  = Fabricate(:language)
      css   = Fabricate(:language)
      rails = Fabricate(:language)
      get :front
      expect(assigns(:languages)).to match_array([html, css, rails])
    end

    it "renders templates :front and no header layout" do
      get :front
      expect(response).to render_template "layouts/no_header"
      expect(response).to render_template :front
    end

    it "redirects to dashboard if user is logged on" do
      set_current_user
      get :front
      expect(response).to redirect_to dashboard_url
    end
  end
end