class CreateBuildingQueueItems < ActiveRecord::Migration[4.2]
  def change
    create_table :building_queue_items do |t|
      t.integer :villa_id
      t.integer :building_id
      t.integer :completion_time

      t.index :villa_id

      t.timestamps
    end
  end
end
