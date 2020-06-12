class CreateResearchQueueItems < ActiveRecord::Migration[4.2]
  def change
    create_table :research_queue_items do |t|
      t.integer :villa_id
      t.integer :research_id
      t.integer :research_time
      t.integer :completion_time

      t.index :villa_id
      t.index :completion_time

      t.timestamps
    end

    change_table :villas do |t|
      t.integer :research_queue_items_count

      t.integer :building_2
      t.integer :research_1
    end
  end
end
