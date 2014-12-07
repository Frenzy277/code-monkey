class AddSupportToQueueItems < ActiveRecord::Migration
  def change
    add_column :queue_items, :support, :string
  end
end
