class Power
  include Consul::Power

  def initialize(player)
    @player = player
  end

  power :villas do
    @player.villas
  end

  power :message_statuses do
    @player.message_statuses
  end

  power :reports do
    @player.reports
  end
end
