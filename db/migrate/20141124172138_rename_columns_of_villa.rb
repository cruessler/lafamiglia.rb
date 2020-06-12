class RenameColumnsOfVilla < ActiveRecord::Migration[4.2]
  def change
    change_table :villas do |t|
      t.rename :pizzas, :resource_1
      t.rename :concrete, :resource_2
      t.rename :suits, :resource_3

      t.rename :house_of_the_family, :building_1
    end
  end
end
