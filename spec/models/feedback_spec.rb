require 'spec_helper'

describe Feedback do

  it { should have_db_index(:giver_id) }
  it { should have_db_index(:skill_id) }
  it { should belong_to(:giver).class_name('User') }
  it { should belong_to(:skill) }
  it { should validate_presence_of(:giver) }
  it { should validate_presence_of(:skill) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:recommended) }

end