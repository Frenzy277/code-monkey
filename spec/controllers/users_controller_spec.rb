require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "renders no header layout" do
      get :new
      should render_with_layout("no_header")
    end
  end

  describe "POST create" do
    context "with valid inputs" do
      before { post :create, user: Fabricate.attributes_for(:user) }
      it { should redirect_to sign_in_url }
      it { should set_the_flash[:success] }
      it "creates the user" do
        expect(User.count).to eq(1)
      end
    end

    context "with invalid inputs" do
      before { post :create, user: Fabricate.attributes_for(:user, email: "foo@bar") }
      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders correct templates" do
        should render_with_layout("no_header")
        should render_template(:new)
      end

      it "sets the @user" do        
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it "sets the @user" do
      alice = Fabricate(:user)
      set_current_user
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it_behaves_like "require sign in" do
      let(:action) do
        alice = Fabricate(:user)
        get :show, id: alice.id
      end
    end
  end
end