module Dispatcher
  class ConquerEvent < Event
    def self.find_until time
      occupations = Occupation.where([ 'succeeds_at <= ?', time ])

      occupations.collect do |o|
        ConquerEvent.new o
      end
    end

    def self.find_time_of_next
      Occupation.minimum :succeeds_at
    end

    def initialize occupation
      @occupation = occupation
    end

    def happens_at
      @occupation.succeeds_at
    end

    def handle dispatcher
      logger.info { "processing conquer event (id: #{@occupation.id}, time: #{happens_at})" }

      origin, target = @occupation.origin, @occupation.target

      old_owner = target.player
      new_owner = origin.player

      logger.info { "#{new_owner} conquers #{target} from #{old_owner}" }

      Villa.transaction do
        # The report has to be delivered before the target’s player is changed
        # as otherwise the target’s player would not receive the report which
        # would instead be sent to the conquering player twice.
        report = ConquestReportGenerator.new(@occupation.succeeds_at)
        report.deliver!(origin, target)

        target.player = new_owner
        target.save

        old_owner.recalc_points!
        new_owner.recalc_points!

        ComebackMovement.create(origin: origin,
                                target: target,
                                units: @occupation.units)

        @occupation.destroy
      end
    end
  end
end
