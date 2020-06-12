class ConvertTimeColumnsToDatetime < ActiveRecord::Migration[4.2]
  def change
    change_table :building_queue_items do |t|
      t.remove :completion_time

      t.datetime :completed_at, index: true
    end

    change_table :research_queue_items do |t|
      t.remove :completion_time

      t.datetime :completed_at, index: true
    end

    change_table :unit_queue_items do |t|
      t.remove :completion_time

      t.datetime :completed_at, index: true
    end

    change_table :messages do |t|
      t.remove :time

      t.datetime :sent_at
    end

    change_table :movements do |t|
      t.remove :arrival

      t.datetime :arrives_at, index: true
    end

    change_table :reports do |t|
      t.remove_index [ :player_id, :time ]
      t.remove :time

      t.datetime :delivered_at
      t.index [ :player_id, :delivered_at ]
    end

    change_table :villas do |t|
      t.remove :last_processed

      t.datetime :processed_until, index: true
    end
  end
end
