class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :giver_id, index: true
      t.integer :skill_id, index: true
      t.text :content
      t.boolean :recommended
      t.timestamp
    end
  end
end
