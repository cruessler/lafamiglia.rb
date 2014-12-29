module Dispatcher
  class Event
    def self.find_until timestamp
      events = subclasses.collect do |c|
        c.find_until timestamp
      end.flatten

      events.sort_by do |event|
        event.time
      end
    end
  end
end

require_dependency 'dispatcher/attack_event'
require_dependency 'dispatcher/build_event'
require_dependency 'dispatcher/comeback_event'
