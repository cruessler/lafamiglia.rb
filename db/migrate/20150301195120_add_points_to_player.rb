class AddPointsToPlayer < ActiveRecord::Migration[4.2]
  def change
    change_table :players do |t|
      t.integer :points
      t.index :points
    end
  end
end
