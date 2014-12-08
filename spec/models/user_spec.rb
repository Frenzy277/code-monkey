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
    should allow_value('user@example.com', 'TEST.A@abc.in', 'user.ab.dot@test.ds.info', 'foo-bar2@baz2.com').for(:email)
  end

  it "does not allow email format" do
    should_not allow_value('foo@bar', "'z\\foo@ex.com", 'foobar.com', 'foo@bar.c', 'foo..bar@ex.com', '>!?#@ex.com', 'mel,bour@ne.aus').for(:email)
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

  describe "#mentor_sessions_not_completed" do
    let(:bob) { Fabricate(:user) }
    subject { bob.mentor_sessions_not_completed }

    it "returns []" do
      expect(subject).to match_array([])
    end

    it "returns 1 mentor session - not completed" do
      Fabricate(:mentoring_session, mentor: bob, status: "completed")
      accepted = Fabricate(:mentoring_session, mentor: bob, status: "accepted")
      expect(subject).to match_array([accepted])
    end

    it "returns many mentor sessions - not completed" do
      Fabricate(:mentoring_session, mentor: bob, status: "completed")
      accepted = Fabricate(:mentoring_session, mentor: bob, status: "accepted")
      pending = Fabricate(:mentoring_session, mentor: bob, status: "pending")
      rejected = Fabricate(:mentoring_session, mentor: bob, status: "rejected")
      expect(subject).to match_array([accepted, pending, rejected])
    end

    it "does not return completed mentor sessions" do
      Fabricate(:mentoring_session, mentor: bob, status: "completed")
      expect(subject).to match_array([])
    end
  end
    
end