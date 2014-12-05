require 'spec_helper'

describe SessionsController do
  
  describe "GET new" do    
    it "redirects logged user to dashboard" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :new
      expect(response).to redirect_to dashboard_url
    end

    it "renders the corrent templates for non logged" do
      get :new
      expect(response).to render_template "layouts/no_header"
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    let!(:alice) { Fabricate(:user, email: "alice@email.com", password: "password") }
    
    context "with valid credentials" do
      it "redirects to dashboard url" do
        post :create, email: alice.email, password: alice.password
        expect(response).to redirect_to dashboard_url
      end

      it "sets session user_id to users id" do
        post :create, email: "ALICE@EMAIL.COM", password: alice.password
        expect(session[:user_id]).to eq(alice.id)
      end
      
      it "sets flash success" do
        post :create, email: alice.email, password: alice.password
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid credentials" do
      before { post :create, email: "ALICE@EMAIL", password: alice.password }
      
      it "does not create session for user" do
        expect(session[:user_id]).to be nil
      end

      it "renders correct templates" do
        expect(response).to render_template "layouts/no_header"
        expect(response).to render_template :new
      end

      it "sets flash danger" do
        expect(flash[:danger]).to be_present
      end
    end
  end

end