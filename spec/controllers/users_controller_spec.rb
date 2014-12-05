require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "renders no header layout" do
      get :new
      expect(response).to render_template "layouts/no_header"
    end
  end

  describe "POST create" do
    context "with valid inputs" do
      it "redirects to sign in url" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_url
      end

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "sets flash success" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not create the user" do
        post :create, user: Fabricate.attributes_for(:user, email: "foo@bar")
        expect(User.count).to eq(0)
      end

      it "renders correct templates :new and no_header layout" do
        post :create, user: Fabricate.attributes_for(:user, email: "foo@bar")
        expect(response).to render_template "layouts/no_header"
        expect(response).to render_template :new
      end

      it "sets the @user" do
        post :create, user: Fabricate.attributes_for(:user, email: "foo@bar")
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end