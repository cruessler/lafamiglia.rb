class AddIndexOnTimeToReports < ActiveRecord::Migration[4.2]
  def change
    change_table :reports do |t|
      t.remove_index :player_id
      t.index [ :player_id, :time ]
    end
  end
end
