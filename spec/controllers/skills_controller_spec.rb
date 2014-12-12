require 'spec_helper'

describe SkillsController do

  describe "GET new" do
    it "sets the @skill" do
      set_current_user
      get :new
      expect(assigns(:skill)).to be_instance_of(Skill)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:ruby)  { Fabricate(:language) }
    before { set_current_user(alice) }

    context "with valid data" do
      before do
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice)
      end

      it { should redirect_to dashboard_url }
      it { should set_the_flash[:success] }
      it "creates the skill under mentor" do
        expect(Skill.first.mentor).to eq(alice)
      end
      it "creates the skill under language" do
        expect(Skill.first.language).to eq(ruby)
      end
    end

    context "with invalid data" do
      before do
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice, experience: "")
      end

      it "does not create the skill" do
        expect(Skill.count).to eq(0)
      end
      it { should render_template(:new) }
      it "sets the @skill" do
        expect(assigns(:skill)).to be_instance_of(Skill)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) do
        post :create, skill: { language: ruby, mentor: alice, experience: "2014-01-01" }
      end
    end
  end
end