require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects logged user to dashboard" do
      set_current_user
      get :new
      should redirect_to dashboard_url
    end

    it "renders the corrent templates for non logged" do
      get :new
      should render_with_layout("no_header")
      should render_template(:new)
    end
  end

  describe "POST create" do
    let!(:alice) do
      Fabricate(:user, email: "alice@email.com", password: "password")
    end

    context "with valid credentials" do
      it "redirects to dashboard url" do
        post :create, email: alice.email, password: alice.password
        should redirect_to dashboard_url
      end

      it "sets session user_id to users id" do
        post :create, email: "ALICE@EMAIL.COM", password: alice.password
        should set_session(:user_id).to alice.id
      end
      
      it "sets flash success" do
        post :create, email: alice.email, password: alice.password
        should set_the_flash[:success]
      end
    end

    context "with invalid credentials" do
      before { post :create, email: "ALICE@EMAIL", password: alice.password }

      it "does not create session for user" do
        should set_session(:user_id).to nil
      end

      it "renders correct templates" do
        should render_with_layout("no_header")
        should render_template(:new)
      end

      it { should set_the_flash.now[:danger] }
    end
  end

  describe "GET destroy" do
    context "for signed in users" do
      before do
        set_current_user
        get :destroy
      end

      it { should redirect_to root_url }
      it { should set_the_flash[:success] }
      it { should set_session(:user_id).to nil }
    end

    it_behaves_like "require sign in" do
      let(:action) { get :destroy }
    end
  end
end