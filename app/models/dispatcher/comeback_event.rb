module Dispatcher
  class ComebackEvent < Event
    def self.find_until timestamp
      comeback_movements = ComebackMovement.where([ 'arrival <= ?', timestamp ])

      comeback_movements.collect do |movement|
        ComebackEvent.new movement
      end
    end

    def self.find_time_of_first
      ComebackMovement.minimum :arrival
    end

    def initialize comeback_movement
      @comeback_movement = comeback_movement
    end

    def time
      @comeback_movement.arrival
    end

    def handle
      puts "processing comeback movement (id: #{@comeback_movement.id}, time: #{Time.at(time)})"
      @comeback_movement.arrive!
    end
  end
end
