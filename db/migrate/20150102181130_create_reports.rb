class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :type
      t.references :player
      t.integer :time
      t.string :title
      t.text :data
      t.boolean :read

      t.timestamps

      t.index :player_id
    end
  end
end
