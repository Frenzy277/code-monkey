class AddMentorIdToQueueItems < ActiveRecord::Migration
  def change
    add_column :queue_items, :mentor_id, :integer
    add_index :queue_items, :mentor_id
  end
end
