class RenameColumnsForOccupation < ActiveRecord::Migration
  def change
    change_table :occupations do |t|
      t.rename :occupying_villa_id, :origin_id
      t.rename :occupied_villa_id, :target_id
    end
  end
end
