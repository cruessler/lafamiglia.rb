class AddIndexToBuildingQueueItems < ActiveRecord::Migration
  def change
    change_table :building_queue_items do |t|
      t.index :completion_time
    end
  end
end
