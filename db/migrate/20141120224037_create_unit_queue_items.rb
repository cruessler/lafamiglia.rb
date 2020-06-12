class CreateUnitQueueItems < ActiveRecord::Migration[4.2]
  def change
    create_table :unit_queue_items do |t|
      t.integer :villa_id
      t.integer :unit_id
      t.integer :number
      t.integer :completion_time

      t.index :villa_id
      t.index :completion_time

      t.timestamps
    end

    change_table :villas do |t|
      t.integer :unit_queue_items_count
      t.integer :used_supply
      t.integer :supply

      t.integer :unit_1
    end
  end
end
