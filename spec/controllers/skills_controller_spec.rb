require 'spec_helper'

describe SkillsController do

  describe "GET new" do
    it "sets the @skill" do
      set_current_user
      get :new
      expect(assigns(:skill)).to be_instance_of(Skill)
    end

    it "for unauthorized users" do
      get :new
      expect(response).to redirect_to root_url
    end
  end

  describe "POST create" do
    context "with valid data" do
      it "redirects to dashboard" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language_id: ruby.id, user_id: alice.id)
        expect(response).to redirect_to dashboard_url
      end
      
      it "creates the skill under mentor" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice)
        expect(Skill.first.mentor).to eq(alice)
      end
      
      it "creates the skill under language" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice)
        expect(Skill.first.language).to eq(ruby)
      end

      it "sets flash success" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid data" do
      it "does not create the skill" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice, experience: "", )
        expect(Skill.count).to eq(0)
      end
      
      it "renders :new template" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice, experience: "", )
        expect(response).to render_template :new
      end

      it "sets the @skill" do
        alice = Fabricate(:user)
        ruby = Fabricate(:language)
        set_current_user(alice)
        
        post :create, skill: Fabricate.attributes_for(:skill, language: ruby, mentor: alice, experience: "", )
        expect(assigns(:skill)).to be_instance_of(Skill)
      end
    end

    it "for unauthorized users" do
      alice = Fabricate(:user)
      ruby = Fabricate(:language)
      post :create, skill: { language: ruby, mentor: alice, experience: "2014-01-01" }
      expect(response).to redirect_to root_url
    end
  end

end