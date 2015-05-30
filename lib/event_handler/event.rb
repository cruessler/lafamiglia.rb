module EventHandler
  class Event
    include Comparable

    def logger
      EventHandler.logger
    end

    def self.find_until time
      subclasses.collect do |c|
        c.find_until time
      end.flatten.sort
    end

    def self.find_time_of_next
      subclasses.collect do |c|
        c.find_time_of_next
      end.compact.min
    end

    def <=> other
      self.happens_at <=> other.happens_at
    end
  end
end

require_dependency 'event_handler/attack_event'
require_dependency 'event_handler/build_event'
require_dependency 'event_handler/comeback_event'
require_dependency 'event_handler/conquer_event'
