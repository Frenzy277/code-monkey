require 'spec_helper'

describe Skill do
  
  it { should have_many(:feedbacks).order(created_at: :desc) }
  it { should have_many(:queue_items).order(:position) }
  it do
    should belong_to(:mentor).class_name('User')
                             .with_foreign_key(:user_id)
  end
  it { should belong_to(:language) }
  it { should validate_presence_of(:mentor) }
  it { should validate_presence_of(:language) }
  it { should validate_presence_of(:experience) }
  it { should have_db_index(:user_id) }
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

  describe "#mentors_queue_total" do
    it "returns count of all mentors queue items" do
      bob = Fabricate(:user)
      skill = Fabricate(:skill, mentor: bob)
      Fabricate.times(3, :queue_item, skill: skill, mentor: bob)
      
      expect(Skill.first.mentors_queue_total).to eq(3)
    end
  end
  
end