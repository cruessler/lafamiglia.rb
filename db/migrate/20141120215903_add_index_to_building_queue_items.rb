class AddIndexToBuildingQueueItems < ActiveRecord::Migration[4.2]
  def change
    change_table :building_queue_items do |t|
      t.index :completion_time
    end
  end
end
