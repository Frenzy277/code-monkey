class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.references :skill, index: true
      t.references :user, index: true
      t.string :status
      t.integer :position
      
      t.timestamps
    end
  end
end
