require 'spec_helper'

describe Skill do
  
  it { should have_many(:feedbacks).order(created_at: :desc) }
  it { should have_many(:mentoring_sessions).order(:position) }
  it { should belong_to(:mentor).class_name('User') }
  it { should belong_to(:language) }
  it { should validate_presence_of(:mentor) }
  it { should validate_presence_of(:language) }
  it { should validate_presence_of(:experience) }
  it { should have_db_index(:mentor_id) }
  it { should have_db_index(:language_id) }

  it "creates skill with helped_total 0" do
    Fabricate(:skill)
    expect(Skill.first.helped_total).to eq(0)
  end

  describe "#total_feedbacks" do
    it "returns 'none' for 0 feedbacks" do
      skill = Fabricate(:skill)
      expect(skill.total_feedbacks).to eq("none")
    end

    it "returns number for number of feedbacks" do
      html = Fabricate(:skill)
      Fabricate(:feedback, skill: html)
      Fabricate(:feedback, skill: html)
      expect(html.total_feedbacks).to eq(2)
    end
  end

  describe "#mentor_sessions_total" do
    it "returns count of all mentor sessions" do
      bob = Fabricate(:user)
      skill = Fabricate(:skill, mentor: bob)
      Fabricate.times(3, :mentoring_session, skill: skill, mentor: bob)
      
      expect(Skill.first.mentor_sessions_total).to eq(3)
    end
  end
  
end