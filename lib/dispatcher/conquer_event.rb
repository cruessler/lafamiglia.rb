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

      old_owner = @occupation.occupied_villa.player
      new_owner = @occupation.occupying_villa.player

      logger.info { "#{new_owner} conquers #{@occupation.occupied_villa} from #{old_owner}" }

      Villa.transaction do
        @occupation.occupied_villa.player = new_owner
        @occupation.occupied_villa.save

        old_owner.recalc_points!
        new_owner.recalc_points!

        ComebackMovement.create(origin: @occupation.occupying_villa,
                                target: @occupation.occupied_villa,
                                units: @occupation.units)

        @occupation.destroy
      end
    end
  end
end
