class AddResourcesToMovements < ActiveRecord::Migration
  def change
    change_table :movements do |t|
      t.float :resource_1
      t.float :resource_2
      t.float :resource_3
    end
  end
end
