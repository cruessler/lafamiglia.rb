class AddIsOccipiedToVillas < ActiveRecord::Migration[4.2]
  def change
    change_table :villas do |t|
      t.boolean :is_occupied
    end
  end
end
