module Dispatcher
  class AttackEvent < Event
    def self.find_until timestamp
      attack_movements = AttackMovement.where([ 'arrival <= ?', timestamp ])

      attack_movements.collect do |movement|
        AttackEvent.new movement
      end
    end

    def initialize attack_movement
      @attack_movement = attack_movement
    end

    def time
      @attack_movement.arrival
    end

    def handle
      puts "processing attack movement (id: #{@attack_movement.id})"
      @attack_movement.cancel!
    end
  end
end
