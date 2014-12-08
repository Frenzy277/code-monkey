class AddMenteeIdToQueueItems < ActiveRecord::Migration
  def change
    rename_column :queue_items, :user_id, :mentee_id
  end
end
