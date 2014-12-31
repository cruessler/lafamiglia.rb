module Dispatcher
  class BuildEvent < Event
    def self.find_until timestamp
      queue_items = BuildingQueueItem.where([ 'completion_time <= ?', timestamp ])

      queue_items.collect do |item|
        BuildEvent.new item
      end
    end

    def self.find_time_of_first
      BuildingQueueItem.minimum :completion_time
    end

    def initialize queue_item
      @queue_item = queue_item
    end

    def time
      @queue_item.completion_time
    end

    def handle
      puts "processing build event (id: #{@queue_item.id}, time: #{Time.at(time)})"
      @queue_item.villa.process_until!(@queue_item.completion_time)
    end
  end
end
