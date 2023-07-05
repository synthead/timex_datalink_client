# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol9
    class TimeName
      include ActiveModel::Validations
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_NAME = [0x31]

      attr_accessor :zone, :name

      validates :zone, inclusion: {
        in: 1..2,
        message: "%{value} is invalid!  Valid zones are 1..2."
      }

      # Create a TimeName instance.
      #
      # @param zone [Integer] Time zone number (1 or 2).
      # @param name [String] Name of time zone (3 chars max).
      # @return [TimeName] TimeName instance.
      def initialize(zone:, name:)
        @zone = zone
        @name = name
      end

      # Compile packets for a time name.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [
          [
            CPACKET_NAME,
            zone,
            name_characters
          ].flatten
        ]
      end

      private

      def name_formatted
        name || "tz#{zone}"
      end

      def name_characters
        chars_for(name_formatted, length: 3, pad: true)
      end
    end
  end
end
