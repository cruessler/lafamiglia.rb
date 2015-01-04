class Power
  include Consul::Power

  def initialize(player)
    @player = player
  end

  power :villas do
    Villa.where(player_id: @player.id)
  end

  power :reports do
    Report.where(player_id: @player.id)
  end
end
