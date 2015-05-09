class AddUnitToMovements < ActiveRecord::Migration
  def change
    change_table :movements do |t|
      t.integer :unit_2
    end
  end
end
