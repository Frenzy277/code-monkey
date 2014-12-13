require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should have_db_index(:email).unique(true) }
  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should validate_presence_of(:balance) }
  it { should have_many(:skills).with_foreign_key(:mentor_id) }
  it { should have_many(:feedbacks).with_foreign_key(:giver_id) }
  it do 
    should have_many(:mentee_sessions).class_name("MentoringSession").with_foreign_key(:mentee_id)
  end
  it do 
    should have_many(:mentor_sessions).class_name("MentoringSession").with_foreign_key(:mentor_id).order(:position)
  end
  it "allows email format" do
    should allow_value('user@example.com', 'TEST.A@abc.in',
      'user.ab.dot@test.ds.info', 'foo-bar2@baz2.com').for(:email)
  end

  it "does not allow email format" do
    should_not allow_value('foo@bar', "'z\\foo@ex.com", 'foobar.com',
      'foo@bar.c', 'foo..bar@ex.com', '>!?#@ex.com', 'mel,bour@ne.aus')
      .for(:email)
  end

  it "creates user with balance of 1" do
    Fabricate(:user)
    expect(User.first.balance).to eq(1)
  end
  
  it "saves user with email downcased" do
    alice = Fabricate.build(:user, email: "ALICE@EXAMPLE.COM")
    alice.save
    expect(User.first.email).to eq("alice@example.com")
  end

  describe "#full_name" do
    it "returns full name combined from first and last name" do
      alice = Fabricate(:user, first_name: "Alice", last_name: "Wang")
      expect(alice.full_name).to eq("Alice Wang")
    end
  end

  describe "#short_name" do
    it "returns full first name and first initial of last name" do
      alice = Fabricate(:user, first_name: "Alice", last_name: "Wang")
      expect(alice.short_name).to eq("Alice W.")
    end
  end

  describe "#mentor?(obj)" do
    it "returns true if user is mentor for the skill" do
      bob = Fabricate(:user)
      skill = Fabricate(:skill, mentor: bob)
      expect(bob.mentor?(skill)).to be true
    end

    it "returns true if user is mentor for the mentoring session" do
      bob = Fabricate(:user)
      mentoring_session = Fabricate(:mentoring_session, mentor: bob)
      expect(bob.mentor?(mentoring_session)).to be true
    end

    it "returns false if user is not mentor for the object" do
      alice = Fabricate(:user)
      skill = Fabricate(:skill)
      expect(alice.mentor?(skill)).to be false
    end
  end

  describe "#has_any_skills?" do
    it "returns true if user has at least 1 skill" do
      bob = Fabricate(:user)
      skill = Fabricate(:skill, mentor: bob)
      expect(bob.has_any_skills?).to be true
    end

    it "returns false if user has no skill" do
      alice = Fabricate(:user)
      expect(alice.has_any_skills?).to be false
    end
  end
end