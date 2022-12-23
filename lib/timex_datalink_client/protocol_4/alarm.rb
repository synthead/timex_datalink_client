# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol4
    class Alarm
      include ActiveModel::Validations
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_ALARM = [0x50]

      attr_accessor :number, :audible, :time, :message

      validates :number, inclusion: {
        in: 1..5,
        message: "value %{value} is invalid!  Valid number values are 1..5."
      }

      # Create an Alarm instance.
      #
      # @param number [Integer] Alarm number (from 1 to 5).
      # @param audible [Boolean] Toggle alarm sounds.
      # @param time [::Time] Time of alarm.
      # @param message [String] Alarm message text.
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
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
        validate!

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
