class RenameUserIdToMentorIdFromSkills < ActiveRecord::Migration
  def change
    rename_column :skills, :user_id, :mentor_id
  end
end
