require 'spec_helper'

describe MentoringSession do
  
  it { should have_db_index(:skill_id) }
  it { should have_db_index(:mentee_id) }
  it { should have_db_index(:mentor_id) }
  it { should belong_to(:skill) }
  it { should belong_to(:mentee).class_name("User") }
  it { should belong_to(:mentor).class_name("User") }
  it { should have_many(:feedbacks) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:skill) }
  it { should validate_presence_of(:mentee) }
  it { should validate_presence_of(:support) }
  it { should validate_inclusion_of(:support)
                                        .in_array(%w(mentoring code\ review)) }
  it { should delegate_method(:mentor_short_name).to(:mentor).as(:short_name) }

  context "if status is not completed" do
    before { subject.stub(:completed?) { false } }
    it { should validate_numericality_of(:position).only_integer }
  end

  context "if status completed" do
    before { subject.stub(:completed?) { true } }
    it { should validate_absence_of(:position) }
  end

  it "sets default status for new mentoring session" do
    Fabricate(:mentoring_session)
    expect(MentoringSession.first.status).to eq("pending")
  end
  
  describe "#feedback_submitted?" do
    it "returns true if feedback for mentoring_session from mentee exists" do
      alice = Fabricate(:user)
      ms = Fabricate(:mentoring_session, mentee: alice)
      Fabricate(:feedback, giver: alice, mentoring_session: ms)
      expect(MentoringSession.first.feedback_submitted?).to be true
    end

    it "returns false if feedback for mentoring_session from mentee is missing" do
      Fabricate(:mentoring_session)
      expect(MentoringSession.first.feedback_submitted?).to be false
    end
  end

  describe "#completed?" do
    it "returns true if status is completed" do
      Fabricate(:mentoring_session, status: "completed", position: nil)
      expect(MentoringSession.first.completed?).to be true
    end

    it "returns false if status is not completed" do
      Fabricate(:mentoring_session, status: "pending")
      expect(MentoringSession.first.completed?).to be false
    end
  end
end