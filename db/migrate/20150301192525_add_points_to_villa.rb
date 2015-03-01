class AddPointsToVilla < ActiveRecord::Migration
  def change
    change_table :villas do |t|
      t.integer :points
    end
  end
end
