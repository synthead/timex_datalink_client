# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Calendar
        include Helpers::FourByteFormatter

        DAY_START_TIME = Time.new(2000)
        DAY_SECONDS = 86400

        EVENTS_BYTES_BASE = 2
        EVENTS_BYTES_EVENT = 4
        EVENTS_BYTES_PHRASE_PACKET = 5

        PACKETS_TERMINATOR = 0x01

        attr_accessor :time, :events

        # Create a Calendar instance.
        #
        # @param time [::Time] Time to set device to.
        # @param events [Array<Event>] Event instances to add to the calendar.
        # @return [Calendar] Calendar instance.
        def initialize(time:, events: [])
          @time = time
          @events = events
        end

        # Compile data for calendar.
        #
        # @return [Array<Integer>] Compiled data for calendar.
        def packet
          [
            events_count,
            event_packets,
            event_phrases,
            time.hour,
            time.min,
            days_from_2000,
            time_formatted,
            PACKETS_TERMINATOR
          ].flatten
        end

        private

        def events_count
          events.count.divmod(256).reverse
        end

        def event_packets
          event_bytes = EVENTS_BYTES_BASE
          event_bytes += EVENTS_BYTES_EVENT * events.count

          [].tap do |event_packets|
            events.each_with_index do |event, event_index|
              event_bytes_formatted = event_bytes.divmod(256).reverse
              event_time_formatted = event.time_formatted(time)

              event_packets << [event_time_formatted, event_bytes_formatted]

              event_bytes += EVENTS_BYTES_PHRASE_PACKET * (1 + event.phrase.length / 4)
            end
          end
        end

        def event_phrases
          phrases = events.map(&:phrase)

          four_byte_format_for(phrases)
        end

        def days_from_2000
          since_start_time_seconds = time - DAY_START_TIME
          since_start_time_days = since_start_time_seconds.to_i / DAY_SECONDS

          since_start_time_days.divmod(256).reverse
        end

        def time_formatted
          five_mintes = (time.hour * 60 + time.min) / 5

          five_mintes.divmod(256).reverse
        end
      end
    end
  end
end
