require 'spec_helper'

describe QueueItem do
  
  it { should have_db_index(:skill_id) }
  it { should have_db_index(:mentee_id) }
  it { should have_db_index(:mentor_id) }
  it { should belong_to(:skill) }
  it { should belong_to(:mentee).class_name("User") }
  it { should belong_to(:mentor).class_name("User") }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:skill) }
  it { should validate_presence_of(:mentee) }
  it { should validate_presence_of(:support) }
  it { should validate_numericality_of(:position).only_integer }
  it { should validate_inclusion_of(:support).in_array(%w(mentoring code\ review)) }
  it { should delegate_method(:mentor).to(:skill) }
  
  it "sets default status for new queue item" do
    Fabricate(:queue_item)
    expect(QueueItem.first.status).to eq("pending")
  end

  describe "#mentor_short_name" do
    it "returns short name of mentor for queue item" do
      john = Fabricate(:user, first_name: "John", last_name: "Doe")
      Fabricate(:queue_item, mentor: john)
      expect(QueueItem.first.mentor_short_name).to eq("John D.")
    end
  end

  describe "#feedback_submitted" do
    it "returns true if feedback for queue_item from mentee exists" do
      alice = Fabricate(:user)
      skill = Fabricate(:skill)
      Fabricate(:queue_item, mentee: alice, skill: skill)
      Fabricate(:feedback, giver: alice, skill: skill)
      expect(QueueItem.first.feedback_submitted).to be true
    end

    it "returns false if feedback for queue_item from mentee is missing" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      skill = Fabricate(:skill, mentor: bob)
      Fabricate(:queue_item, skill: skill, mentor: bob, mentee: alice)
      expect(QueueItem.first.feedback_submitted).to be false
    end
  end

end




