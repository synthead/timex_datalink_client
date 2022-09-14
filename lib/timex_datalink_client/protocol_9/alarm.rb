# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol9
    class Alarm
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_ALARM = [0x50]

      attr_accessor :number, :audible, :time, :message, :month, :day

      # Create an Alarm instance.
      #
      # @param number [Integer] Alarm number (from 1 to 10).
      # @param audible [Boolean] Toggle alarm sounds.
      # @param time [::Time] Time of alarm.
      # @param message [String] Alarm message text.
      # @param month [Integer, nil] Month of alarm.
      # @param day [Integer, nil] Day of alarm.
      # @return [Alarm] Alarm instance.
      def initialize(number:, audible:, time:, message:, month: nil, day: nil)
        @number = number
        @audible = audible
        @time = time
        @message = message
        @month = month
        @day = day
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
            month.to_i,
            day.to_i,
            audible_integer,
            message_characters
          ].flatten
        ]
      end

      private

      def message_characters
        chars_for(message, length: 16, pad: true)
      end

      def audible_integer
        audible ? 1 : 0
      end
    end
  end
end
