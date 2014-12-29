require_dependency 'lafamiglia'

module Dispatcher
  class Dispatcher
    def initialize
      @running = false
      @sleep_time = 5
    end

    def stop
      @running = false
    end

    def run
      @running = true

      while @running
        now = Time.now.to_i
        events = Event.find_until(now)

        if events.count > 0
          puts "handling #{events.count} events until #{now}"
          until events.empty?
            event = events.shift
            LaFamiglia.clock event.time
            event.handle
          end
        else
          puts "nothing to handle until #{now}"
        end

        puts "sleeping for #{@sleep_time} seconds …"
        sleep @sleep_time
      end
    end
  end
end
