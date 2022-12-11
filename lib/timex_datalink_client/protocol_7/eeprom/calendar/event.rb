# frozen_string_literal: true

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Calendar
        class Event
          FIVE_MINUTES_SECONDS = 300

          attr_accessor :time, :phrase

          # Create an Event instance.
          #
          # @param time [::Time] Time of event.
          # @param phrase [Array<Integer>] Phrase for event.
          # @return [Event] Event instance.
          def initialize(time:, phrase:)
            @time = time
            @phrase = phrase
          end

          def time_formatted(device_time)
            device_time_midnight = Time.new(device_time.year, device_time.month, device_time.day)
            seconds = (time - device_time_midnight).to_i
            five_minutes = seconds / FIVE_MINUTES_SECONDS

            five_minutes.divmod(256).reverse
          end
        end
      end
    end
  end
end
