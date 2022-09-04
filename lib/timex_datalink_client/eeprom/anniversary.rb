# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class Anniversary
      prepend PrependLength
      include CharEncoder

      attr_accessor :time, :anniversary

      def initialize(time:, anniversary:)
        @time = time
        @anniversary = anniversary
      end

      def packet
        [
          time.month,
          time.day,
          anniversary_characters
        ].flatten
      end

      private

      def anniversary_characters
        eeprom_chars_for(anniversary)
      end
    end
  end
end
