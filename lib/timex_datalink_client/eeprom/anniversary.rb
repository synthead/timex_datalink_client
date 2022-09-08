# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Eeprom
    class Anniversary
      include Helpers::CharEncoders
      prepend Helpers::LengthPacketWrapper

      attr_accessor :time, :anniversary

      # Create an Anniversary instance.
      #
      # @param time [::Time] Time of anniversary.
      # @param anniversary [String] Anniversary text.
      # @return [Anniversary] Anniversary instance.
      def initialize(time:, anniversary:)
        @time = time
        @anniversary = anniversary
      end

      # Compile a packet for an anniversary.
      #
      # @return [Array<Integer>] Array of integers that represent bytes.
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
