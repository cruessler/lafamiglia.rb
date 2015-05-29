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
      @origin, @target = @attack_movement.origin, @attack_movement.target
    end

    def happens_at
      @happens_at ||= @attack_movement.arrives_at
    end

    def destroy_occupation
      @target.occupation.destroy
      @target.occupation.origin.used_supply -= @combat.defender_supply_loss
    end

    def handle_occupation dispatcher
      destroy_occupation if @target.occupied?

      occupation = Occupation.create succeeds_at: LaFamiglia.now + @target.duration_of_occupation,
                                     origin: @origin,
                                     target: @target,
                                     units: @combat.attacker_after_combat

      @target.unit_queue_items.delete_all

      @attack_movement.destroy

      dispatcher.add_event_to_queue ConquerEvent.new(occupation)
    end

    def handle_plundering dispatcher
      destroy_occupation if @target.occupied?

      comeback = @attack_movement.cancel!

      comeback.units = @combat.attacker_after_combat
      comeback.resources = @combat.plundered_resources
      @target.subtract_resources!(@combat.plundered_resources)

      comeback.save

      dispatcher.add_event_to_queue ComebackEvent.new(comeback)
    end

    def handle_defense dispatcher
      @attack_movement.destroy

      if @target.occupied?
        if @combat.defender_after_combat[LaFamiglia.config.unit_for_occupation] == 0
          if @combat.defender_survived?
            @target.occupation.subtract_units!(@combat.defender_loss)
            comeback = @target.occupation.cancel!

            dispatcher.add_event_to_queue ComebackEvent.new(comeback)
          else
            @target.occupation.destroy
          end

          @target.occupation.origin.used_supply -= @combat.defender_supply_loss
        end
      else
        @target.subtract_units!(@combat.defender_loss)
        @target.used_supply -= @combat.defender_supply_loss
      end
    end

    def handle dispatcher
      logger.info { "processing attack movement (id: #{@attack_movement.id}, time: #{happens_at})" }

      Villa.transaction do
        @origin.process_until! happens_at
        @target.process_until! happens_at

        @target.occupation.origin.process_until! happens_at if @target.occupied?
      end

      attacker = @attack_movement.attack_values
      defender = @attack_movement.defense_values

      @combat = Combat.new(attacker, defender)
      @combat.calculate

      logger.info { "attacker: #{@combat.attacker}, defender: #{@combat.defender}" }
      logger.info { "attack value: #{@combat.attack_value}, defense value: #{@combat.defense_value}" }
      logger.info { "attacker loss: #{@combat.attacker_loss}, defender loss: #{@combat.defender_loss}" }
      logger.info { "plundered_resources: #{@combat.plundered_resources}" }
      logger.info { "attacker_can_occupy?: #{@combat.attacker_can_occupy?}" }

      Villa.transaction do
        # The report has to be delivered before the target is possibly occupied
        # as otherwise the target’s player would not receive the report which
        # would instead be sent to the occupying player twice.
        report = CombatReportGenerator.new(@attack_movement.arrives_at, @combat.report_data)
        report.deliver!(@origin, @target)

        case
        when @combat.attacker_can_occupy?
          handle_occupation dispatcher
        when @combat.attacker_survived?
          handle_plundering dispatcher
        else
          handle_defense dispatcher
        end

        @origin.used_supply -= @combat.attacker_supply_loss
        @target.save
        @origin.save

        @target.occupation.origin.save if @target.occupied?
      end
    end
  end
end
