class RenameSkillIdFromFeedbacks < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :skill_id, :mentoring_session_id
  end
end
