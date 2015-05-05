class CreateOccupations < ActiveRecord::Migration
  def change
    create_table :occupations do |t|
      t.datetime :succeeds_at

      t.integer :occupied_villa_id
      t.integer :occupying_villa_id

      t.integer :unit_1
      t.integer :unit_2

      t.index :occupied_villa_id, unique: true
      t.index :occupying_villa_id

      t.timestamps
    end

    change_table :villas do |t|
      t.integer :unit_2
    end
  end
end
