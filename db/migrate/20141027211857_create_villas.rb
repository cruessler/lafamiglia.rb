class CreateVillas < ActiveRecord::Migration[4.2]
  def change
    create_table :villas do |t|
      t.integer :x
      t.integer :y
      t.string :name

      t.integer :player_id

      t.index [ :x, :y ], unique: true
      t.index :player_id

      t.timestamps
    end
  end
end
