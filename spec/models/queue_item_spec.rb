require 'spec_helper'

describe QueueItem do
  
  it { should have_db_index(:skill_id) }
  it { should have_db_index(:user_id) }
  it { should belong_to(:skill) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:skill) }
  it { should validate_presence_of(:user) }
  it { should validate_numericality_of(:position).only_integer }
  
end