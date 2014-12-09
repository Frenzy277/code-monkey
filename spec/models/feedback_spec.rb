require 'spec_helper'

describe Feedback do

  it { should have_db_index(:giver_id) }
  it { should have_db_index(:mentoring_session_id) }
  it { should belong_to(:giver).class_name('User') }
  it { should belong_to(:mentoring_session) }
  it { should validate_presence_of(:giver) }
  it { should validate_presence_of(:mentoring_session) }
  it { should validate_presence_of(:content) }

  describe "#language_name" do
    it "returns language name for skill on whichs feedback is given" do
      language = Fabricate(:language, name: "HTML")
      skill    = Fabricate(:skill, language: language)
      ms       = Fabricate(:mentoring_session, skill: skill)
      feedback = Fabricate(:feedback, mentoring_session: ms)
      expect(Feedback.first.language_name).to eq("HTML")
    end    
  end

end