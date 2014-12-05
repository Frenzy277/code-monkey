class AdditionalToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :helped_total, :integer, default: 0
    add_column :skills, :experience, :date
  end
end
