require 'benchmark/ips'

namespace :benchmark do
  desc "Benchmark ranking with 50,000 players"
  task ranking: :environment do
    Player.transaction do
      1.upto(50_000) do |i|
        Player.create(name: "player #{i}",
                      password: 'password',
                      password_confirmation: 'password',
                      points: Random.rand(10_000))
      end
    end

    Benchmark.ips do |x|
      [ 0, 10, 100, 1000 ].each do |i|
        x.report("get ranking page #{i}") do
          players = Player.order('players.points DESC')
                          .page(i)
        end
      end

      x.report("get ranking for random player") do
        p = Player.order('RANDOM()').first

        players_with_more_points_count = Player.where([ 'points > ?', p.points ]).count

        players = Player.order('players.points DESC')
                        .page(players_with_more_points_count / Kaminari.config.default_per_page)
      end

      x.compare!
    end
  end
end
