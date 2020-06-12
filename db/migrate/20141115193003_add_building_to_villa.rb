class AddBuildingToVilla < ActiveRecord::Migration[4.2]
  def change
    change_table(:villas) do |t|
      t.integer :house_of_the_family
    end
  end
end
