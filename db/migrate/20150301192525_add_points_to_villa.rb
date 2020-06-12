class AddPointsToVilla < ActiveRecord::Migration[4.2]
  def change
    change_table :villas do |t|
      t.integer :points
    end
  end
end
