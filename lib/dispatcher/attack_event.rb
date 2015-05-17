module Dispatcher
  class AttackEvent < Event
    def self.find_until time
      attack_movements = AttackMovement.where([ 'arrives_at <= ?', time ])

      attack_movements.collect do |movement|
        AttackEvent.new movement
      end
    end

    def self.find_time_of_next
      AttackMovement.minimum :arrives_at
    end

    def initialize attack_movement
      @attack_movement = attack_movement
    end

    def happens_at
      @attack_movement.arrives_at
    end

    def handle dispatcher
      logger.info { "processing attack movement (id: #{@attack_movement.id}, time: #{happens_at})" }

      origin, target = @attack_movement.origin, @attack_movement.target

      attacker = @attack_movement.units.merge(origin.researches)
      defender = target.buildings.merge(target.units).merge(target.researches).merge(target.resources)

      origin.process_until! @attack_movement.arrives_at
      target.process_until! @attack_movement.arrives_at

      combat = Combat.new(attacker, defender)
      combat.calculate

      logger.info { "attacker: #{combat.attacker}, defender: #{combat.defender}" }
      logger.info { "attack value: #{combat.attack_value}, defense value: #{combat.defense_value}" }
      logger.info { "attacker loss: #{combat.attacker_loss}, defender loss: #{combat.defender_loss}" }
      logger.info { "plundered_resources: #{combat.plundered_resources}" }
      logger.info { "attacker_can_occupy?: #{combat.attacker_can_occupy?}" }

      Villa.transaction do
        if combat.attacker_can_occupy?
          occupation = Occupation.create succeeds_at: LaFamiglia.now + LaFamiglia.config.duration_of_occupation,
                                         occupied_villa: target,
                                         occupying_villa: origin,
                                         units: combat.attacker_after_combat

          target.unit_queue_items.delete_all

          @attack_movement.destroy

          dispatcher.add_event_to_queue ConquerEvent.new(occupation)
        else
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
        end

        target.subtract_units!(combat.defender_loss)
        target.used_supply -= combat.defender_supply_loss
        origin.used_supply -= combat.attacker_supply_loss
        target.save
        origin.save

        report = CombatReportGenerator.new(@attack_movement.arrives_at, combat.report_data)
        report.deliver!(origin, target)
      end
    end
  end
end
