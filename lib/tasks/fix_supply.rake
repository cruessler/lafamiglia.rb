namespace :data do
  desc "Fix supply"
  task fix_supply: :environment do
    Villa.transaction do
      Villa.all.each do |v|
        LaFamiglia.units.each do |u|
          used_supply = LaFamiglia.units.inject(0) do |supply, u|
            supply + u.supply(v.send(u.key))
          end
          v.update_attribute :used_supply, used_supply
        end
      end
    end
  end
end
