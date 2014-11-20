class CreateBuildingQueueItems < ActiveRecord::Migration
  def change
    create_table :building_queue_items do |t|
      t.integer :villa_id
      t.integer :building_id
      t.integer :completion_time

      t.index :villa_id
      t.integer :completion_time

      t.timestamps
    end
  end
end
