# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol9
    class TimeName
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_NAME = [0x31]

      attr_accessor :zone, :name

      # Create a TimeName instance.
      #
      # @param zone [Integer] Time zone number (1 or 2).
      # @param name [String] Name of time zone (3 chars max)
      # @return [TimeName] TimeName instance.
      def initialize(zone:, name:)
        @zone = zone
        @name = name
      end

      # Compile packets for a time name.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [
          [
            CPACKET_NAME,
            zone,
            name_characters
          ].flatten
        ]
      end

      private

      def name_characters
        chars_for(name, length: 3, pad: true)
      end
    end
  end
end
