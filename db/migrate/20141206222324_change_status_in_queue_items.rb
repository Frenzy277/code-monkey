class ChangeStatusInQueueItems < ActiveRecord::Migration
  def change
    change_column :queue_items, :status, :string, default: 'pending'
  end
end
