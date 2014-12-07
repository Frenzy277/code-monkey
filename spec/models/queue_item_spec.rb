require 'spec_helper'

describe QueueItem do
  
  it { should have_db_index(:skill_id) }
  it { should have_db_index(:user_id) }
  it { should belong_to(:skill) }
  it { should belong_to(:mentee).class_name("User").with_foreign_key(:user_id) }
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

end