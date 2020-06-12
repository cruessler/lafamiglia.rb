class AddBuildTimeToBuildingQueueItem < ActiveRecord::Migration[4.2]
  def change
    change_table(:building_queue_items) do |t|
      t.integer :build_time
    end
  end
end
