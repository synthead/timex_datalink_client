# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol3
    class Alarm
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_ALARM = [0x50]

      MESSAGE_LENGTH = 8

      attr_accessor :number, :audible, :time, :message

      # Create an Alarm instance.
      #
      # @param number [Integer] Alarm number (from 1 to 5).
      # @param audible [Boolean] Toggle alarm sounds.
      # @param time [::Time] Time of alarm.
      # @param message [String] Alarm message text.
      # @return [Alarm] Alarm instance.
      def initialize(number:, audible:, time:, message:)
        @number = number
        @audible = audible
        @time = time
        @message = message
      end

      # Compile packets for an alarm.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [
          [
            CPACKET_ALARM,
            number,
            time.hour,
            time.min,
            0,
            0,
            message_characters,
            audible_integer
          ].flatten
        ]
      end

      private

      def message_characters
        chars_for(message, length: 8, pad: true)
      end

      def audible_integer
        audible ? 1 : 0
      end
    end
  end
end
