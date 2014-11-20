class AddBuildTimeToBuildingQueueItem < ActiveRecord::Migration
  def change
    change_table(:building_queue_items) do |t|
      t.integer :build_time
    end
  end
end
