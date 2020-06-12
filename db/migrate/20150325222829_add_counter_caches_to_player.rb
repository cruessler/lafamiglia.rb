class AddCounterCachesToPlayer < ActiveRecord::Migration[4.2]
  def change
    change_table :players do |t|
      t.integer :unread_messages_count
      t.integer :unread_reports_count
    end
  end
end
