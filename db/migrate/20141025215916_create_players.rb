class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.string :name
      t.index :name, unique: true

      t.timestamps
    end
  end
end
