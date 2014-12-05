class AddIndexToFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, :giver_id
    add_index :feedbacks, :skill_id
  end
end
