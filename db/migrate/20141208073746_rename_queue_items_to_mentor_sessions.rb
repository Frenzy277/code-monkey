class RenameQueueItemsToMentorSessions < ActiveRecord::Migration
  def change
    rename_table :queue_items, :mentoring_sessions
  end
end
