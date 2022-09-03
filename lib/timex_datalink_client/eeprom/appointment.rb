# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class Appointment
      include CharEncoder

      attr_accessor :time, :message

      def initialize(time:, message:)
        @time = time
        @message = message
      end

      def packet
        [length, packet_array].flatten.pack("C*").force_encoding("UTF-8")
      end

      private

      def packet_array
        [
          time.month,
          time.day,
          time_15m,
          message_characters
        ].flatten
      end

      def time_15m
        time.hour * 4 + time.min / 15
      end

      def message_characters
        eeprom_chars_for(message)
      end

      def length
        packet_array.length + 1
      end
    end
  end
end
