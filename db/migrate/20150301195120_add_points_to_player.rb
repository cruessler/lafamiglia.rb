class AddPointsToPlayer < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.integer :points
      t.index :points
    end
  end
end
