module Dispatcher
  class EventLoop
    def logger
      ::Dispatcher.logger
    end

    def add_event_to_queue event
      if event.happens_at <= @process_until
        @events << event
        @events.sort!
      end
    end

    def process_events_until! time
      @process_until = time
      @events = Event.find_until @process_until

      if @events.count > 0
        logger.info { "handling #{@events.count} events until #{Time.at(@process_until)}" }

        until @events.empty?
          event = @events.shift
          LaFamiglia.clock event.happens_at
          event.handle self
        end
      else
        logger.info { "nothing to handle until #{Time.at(@process_until)}" }
      end
    end

    def wait_for_next_event timeout = nil
      read_sockets, = IO.select [ @socket ], [], [], timeout

      if read_sockets # notification from webapp: event created
        if read_socket = read_sockets[0]
          client = read_socket.accept
          happens_at = Time.parse(client[0].read)
          client[0].close

          if happens_at > Time.now
            if @time_of_next_event.nil? || happens_at < @time_of_next_event
              @time_of_next_event = happens_at
            end
          end
        end
      else            # timeout reached
        @time_of_next_event = Event.find_time_of_next
      end
    end

    def run
      @time_of_next_event = Event.find_time_of_next

      Socket.unix_server_socket (Dir.home + "/tmp/lafamiglia.sock") do |socket|
        @socket = socket

        loop do
          now = Time.now

          case
          when @time_of_next_event.nil?
            logger.info "IO.select without timeout"

            wait_for_next_event
          when @time_of_next_event > now
            timeout = (@time_of_next_event - now).ceil
            logger.info { "IO.select with timeout #{timeout}" }

            wait_for_next_event timeout
          else
            process_events_until! now
            @time_of_next_event = Event.find_time_of_next
          end
        end
      end
    end
  end
end
