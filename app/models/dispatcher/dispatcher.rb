require_dependency 'lafamiglia'

module Dispatcher
  class Dispatcher
    def add_event_to_queue event
      if event.time <= @process_until
        @events << event
        @events.sort!
      end
    end

    def process_events_until! timestamp
      @process_until = timestamp
      @events = Event.find_until @process_until

      if @events.count > 0
        puts "handling #{@events.count} events until #{Time.at(@process_until)}"
        until @events.empty?
          event = @events.shift
          LaFamiglia.clock event.time
          event.handle self
        end
      else
        puts "nothing to handle until #{Time.at(@process_until)}"
      end
    end

    def wait_for_next_event timeout = nil
      read_sockets, = IO.select [ @socket ], [], [], timeout

      if read_sockets # notification from webapp: event created
        if read_socket = read_sockets[0]
          client = read_socket.accept
          time = client[0].read.to_i
          client[0].close

          if time > Time.now.to_i
            if @time_of_next_event.nil? || time < @time_of_next_event
              @time_of_next_event = time
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
          now = Time.now.to_i

          case
          when @time_of_next_event.nil?
            puts "IO.select without timeout"
            wait_for_next_event
          when @time_of_next_event > now
            timeout = @time_of_next_event - now
            puts "IO.select with timeout #{timeout}"
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
