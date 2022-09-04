# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class Anniversary
      include CharEncoder

      attr_accessor :time, :anniversary

      def initialize(time:, anniversary:)
        @time = time
        @anniversary = anniversary
      end

      def packet
        [length] + packet_array
      end

      private

      def packet_array
        [
          time.month,
          time.day,
          anniversary_characters
        ].flatten
      end

      def anniversary_characters
        eeprom_chars_for(anniversary)
      end

      def length
        packet_array.length + 1
      end
    end
  end
end
