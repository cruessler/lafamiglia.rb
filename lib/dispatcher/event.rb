module Dispatcher
  class Event
    include Comparable

    def logger
      ::Dispatcher.logger
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

require_dependency 'dispatcher/attack_event'
require_dependency 'dispatcher/build_event'
require_dependency 'dispatcher/comeback_event'
require_dependency 'dispatcher/conquer_event'
