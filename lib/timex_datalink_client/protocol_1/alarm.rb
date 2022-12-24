# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol1
    class Alarm
      include ActiveModel::Validations
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_ALARM = [0x50]
      CPACKET_ALARM_SILENT = [0x70, 0x00]

      ALARM_SILENT_START_INDEX = 0x61

      attr_accessor :number, :audible, :time, :message, :month, :day

      validates :number, inclusion: {
        in: 1..5,
        message: "value %{value} is invalid!  Valid number values are 1..5."
      }

      validates :month, inclusion: {
        in: 1..12,
        allow_nil: true,
        message: "%{value} is invalid!  Valid months are 1..12 and nil."
      }

      validates :day, inclusion: {
        in: 1..31,
        allow_nil: true,
        message: "%{value} is invalid!  Valid days are 1..31 and nil."
      }

      # Create an Alarm instance.
      #
      # @param number [Integer] Alarm number (from 1 to 5).
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
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [alarm_data_packet].tap do |packets|
          packets << alarm_silent_packet unless audible
        end
      end

      private

      def alarm_data_packet
        [
          CPACKET_ALARM,
          number,
          time.hour,
          time.min,
          month.to_i,
          day.to_i,
          message_characters,
          audible_integer
        ].flatten
      end

      def alarm_silent_packet
        [
          CPACKET_ALARM_SILENT,
          alarm_silent_index,
          0
        ].flatten
      end

      def message_characters
        chars_for(message, length: 8, pad: true)
      end

      def audible_integer
        audible ? 1 : 0
      end

      def alarm_silent_index
        ALARM_SILENT_START_INDEX + number
      end
    end
  end
end
