class CreateMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :messages do |t|
      t.integer :sender_id, index: true
      t.text :text
      t.integer :time, index: true

      t.timestamps
    end

    create_join_table :messages, :players, table_name: "messages_receivers" do |t|
      t.index :message_id
      t.index :player_id
    end
  end
end
