module Dispatcher
  class BuildEvent < Event
    def self.find_until time
      queue_items = BuildingQueueItem.where([ 'completed_at <= ?', time ])

      queue_items.collect do |item|
        BuildEvent.new item
      end
    end

    def self.find_time_of_next
      BuildingQueueItem.minimum :completed_at
    end

    def initialize queue_item
      @queue_item = queue_item
    end

    def happens_at
      @queue_item.completed_at
    end

    def handle dispatcher
      puts "processing build event (id: #{@queue_item.id}, time: #{happens_at})"
      @queue_item.villa.process_until!(@queue_item.completed_at)
    end
  end
end
