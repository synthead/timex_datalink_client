# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Eeprom
    class Anniversary
      include Helpers::CharEncoders
      prepend Helpers::LengthPacketWrapper

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
