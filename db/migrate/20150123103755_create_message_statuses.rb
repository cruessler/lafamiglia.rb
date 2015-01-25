class CreateMessageStatuses < ActiveRecord::Migration
  def change
    create_table :message_statuses do |t|
      t.references :player, index: true
      t.references :message, index: true

      t.boolean :read

      t.timestamps
    end
  end
end
