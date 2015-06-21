namespace :data do
  desc "Fix supply"
  task fix_supply: :environment do
    Villa.transaction do
      Villa.all.each do |v|
        used_supply = LaFamiglia.units.inject(0) do |supply, u|
          supply + u.supply(v[u.key])
        end

        used_supply += v.outgoings.inject(0) do |supply, o|
          supply + LaFamiglia.units.inject(0) do |supply, u|
            supply + u.supply(o[u.key])
          end
        end

        used_supply += v.occupations.inject(0) do |supply, o|
          supply + LaFamiglia.units.inject(0) do |supply, u|
            supply + u.supply(o[u.key])
          end
        end

        v.update_attribute :used_supply, used_supply
      end
    end
  end
end
