module EventHandler
  class ComebackEvent < Event
    def self.find_until time
      comeback_movements = ComebackMovement.where([ 'arrives_at <= ?', time ])

      comeback_movements.collect do |movement|
        ComebackEvent.new movement
      end
    end

    def self.find_time_of_next
      ComebackMovement.minimum :arrives_at
    end

    def initialize comeback_movement
      @comeback_movement = comeback_movement
    end

    def happens_at
      @comeback_movement.arrives_at
    end

    def handle event_handler
      logger.info { "processing comeback movement (id: #{@comeback_movement.id}, time: #{happens_at})" }

      @comeback_movement.arrive!
    end
  end
end
