require 'spec_helper'

describe Skill do
  
  # it { should have_many(:feedbacks) }
  it do
    should belong_to(:mentor).class_name('User')
                             .with_foreign_key(:user_id)
  end
  it { should belong_to(:language) }
  it { should validate_presence_of(:mentor) }
  it { should validate_presence_of(:language) }
  it { should validate_presence_of(:experience) }

  it "creates skill with helped_total 0" do
    Fabricate(:skill)
    expect(Skill.first.helped_total).to eq(0)
  end

  describe "#total_feedbacks" do
    it "returns 'none' for 0 feedbacks" do
      
    end

    it "returns 1 for 1 feedback"
    it "returns 10 for 10 feedbacks"
  end
  
end