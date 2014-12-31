require_dependency 'lafamiglia'

module Dispatcher
  class Dispatcher
    def initialize
      @sleep_time = 5
    end

    def process_events_until! timestamp
      events = Event.find_until timestamp

      if events.count > 0
        puts "handling #{events.count} events until #{Time.at(timestamp)}"
        until events.empty?
          event = events.shift
          LaFamiglia.clock event.time
          event.handle
        end
      else
        puts "nothing to handle until #{Time.at(timestamp)}"
      end
    end

    def run
      process_events_until! Time.now.to_i
      time_of_first_event = Event.find_time_of_first

      Socket.unix_server_socket (Dir.home + "/tmp/lafamiglia.sock") do |socket|
        loop do
          if time_of_first_event
            timeout = time_of_first_event - Time.now.to_i
            puts "IO.select with timeout #{timeout}"
            read_sockets, = IO.select [ socket ], [], [], timeout
          else
            puts "IO.select without timeout"
            read_sockets, = IO.select [ socket ], [], [], nil
          end

          if read_sockets # notification from webapp: event created
            if read_socket = read_sockets[0]
              client = read_socket.accept
              time = client[0].read.to_i
              client[0].close

              if time > Time.now.to_i
                unless time_of_first_event && time > time_of_first_event
                  time_of_first_event = time
                end
              end
            end
          else            # timeout reached
            process_events_until! time_of_first_event
            time_of_first_event = Event.find_time_of_first
          end
        end
      end
    end
  end
end
