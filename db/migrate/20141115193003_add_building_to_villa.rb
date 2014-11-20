class AddBuildingToVilla < ActiveRecord::Migration
  def change
    change_table(:villas) do |t|
      t.integer :house_of_the_family
    end
  end
end
