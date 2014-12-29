class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :type
      t.integer :arrival
      t.integer :origin_id
      t.integer :target_id

      t.integer :unit_1

      t.timestamps

      t.index :origin_id
      t.index :target_id
      t.index :arrival
    end
  end
end
