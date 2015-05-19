class AddIsOccipiedToVillas < ActiveRecord::Migration
  def change
    change_table :villas do |t|
      t.boolean :is_occupied
    end
  end
end
