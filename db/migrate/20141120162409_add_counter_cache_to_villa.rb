class AddCounterCacheToVilla < ActiveRecord::Migration[4.2]
  def change
    change_table(:villas) do |t|
      t.integer :building_queue_items_count
    end
  end
end
