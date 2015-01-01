module Dispatcher
  class Event
    include Comparable

    def self.find_until timestamp
      subclasses.collect do |c|
        c.find_until timestamp
      end.flatten.sort
    end

    def self.find_time_of_next
      subclasses.collect do |c|
        c.find_time_of_next
      end.compact.min
    end

    def <=> other
      self.time <=> other.time
    end
  end
end

require_dependency 'dispatcher/attack_event'
require_dependency 'dispatcher/build_event'
require_dependency 'dispatcher/comeback_event'
