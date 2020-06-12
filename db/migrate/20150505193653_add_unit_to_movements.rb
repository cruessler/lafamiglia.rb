class AddUnitToMovements < ActiveRecord::Migration[4.2]
  def change
    change_table :movements do |t|
      t.integer :unit_2
    end
  end
end
