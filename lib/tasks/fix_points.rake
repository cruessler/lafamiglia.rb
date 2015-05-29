namespace :data do
  desc "Fix points (of villas and players)"
  task fix_points: :environment do
    Villa.transaction do
      Villa.all.each do |v|
        v.recalc_points
        v.save
      end
    end

    Player.transaction do
      Player.all.each do |p|
        p.recalc_points!
      end
    end
  end
end
