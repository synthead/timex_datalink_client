# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class Appointment
      prepend PrependLength
      include CharEncoder

      attr_accessor :time, :message

      def initialize(time:, message:)
        @time = time
        @message = message
      end

      def packet
        [
          time.month,
          time.day,
          time_15m,
          message_characters
        ].flatten
      end

      private

      def time_15m
        time.hour * 4 + time.min / 15
      end

      def message_characters
        eeprom_chars_for(message)
      end
    end
  end
end
