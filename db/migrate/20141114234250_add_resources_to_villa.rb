class AddResourcesToVilla < ActiveRecord::Migration[4.2]
  def change
    change_table(:villas) do |t|
      t.float :pizzas
      t.float :concrete
      t.float :suits
      t.integer :storage_capacity
      t.integer :last_processed
    end
  end
end
