namespace :data do
  desc "Fix unit columns"
  task fix_unit_columns: :environment do
    Villa.transaction do
      Villa.all.each do |v|
        LaFamiglia.units.each do |u|
          v.update_attribute u.key, 0 if v.send(u.key).nil?
        end
      end
    end
  end
end
