module Dispatcher
  class AttackEvent < Event
    def self.find_until timestamp
      attack_movements = AttackMovement.where([ 'arrival <= ?', timestamp ])

      attack_movements.collect do |movement|
        AttackEvent.new movement
      end
    end

    def self.find_time_of_next
      AttackMovement.minimum :arrival
    end

    def initialize attack_movement
      @attack_movement = attack_movement
    end

    def time
      @attack_movement.arrival
    end

    def handle dispatcher
      puts "processing attack movement (id: #{@attack_movement.id}, time: #{Time.at(time)})"
      origin, target = @attack_movement.origin, @attack_movement.target

      attacker = @attack_movement.units.merge(origin.researches)
      defender = target.buildings.merge(target.units).merge(target.researches).merge(target.resources)

      origin.process_until! @attack_movement.arrival
      target.process_until! @attack_movement.arrival

      combat = Combat.new(attacker, defender)
      combat.calculate

      Villa.transaction do
        if combat.attacker_survived?
          comeback = @attack_movement.cancel!

          comeback.units = combat.attacker_after_combat
          comeback.resources = combat.plundered_resources
          target.subtract_resources!(combat.plundered_resources)

          comeback.save

          dispatcher.add_event_to_queue ComebackEvent.new(comeback)
        else
          @attack_movement.destroy
        end

        target.subtract_units!(combat.defender_loss)
        target.used_supply -= combat.defender_supply_loss
        origin.used_supply -= combat.attacker_supply_loss
        target.save
        origin.save

        report = CombatReportGenerator.new(@attack_movement.arrival, combat.report_data)
        report.deliver!(origin, target)
      end
    end
  end
end
