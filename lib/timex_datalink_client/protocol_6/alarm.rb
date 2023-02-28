# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol6
    class Alarm
      include ActiveModel::Validations
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_ALARM = 0x51

      VALID_DAYS_IN_MONTH = {
        1 => 1..31,
        2 => 1..29,
        3 => 1..31,
        4 => 1..30,
        5 => 1..31,
        6 => 1..30,
        7 => 1..31,
        8 => 1..31,
        9 => 1..30,
        10 => 1..31,
        11 => 1..30,
        12 => 1..31
      }.freeze

      ALARM_STATUS_MAP = {
        disarmed: 0,
        armed: 1,
        unused: 2
      }.freeze

      DEFAULT_TIME = Time.new(0, 1, 1, 6, 0)

      attr_accessor :number, :status, :time, :message, :month, :day

      validates :number, inclusion: {
        in: 1..8,
        message: "value %{value} is invalid!  Valid number values are 1..8."
      }

      validates :status, inclusion: {
        in: ALARM_STATUS_MAP.keys,
        message: "%{value} is invalid!  Valid date formats are #{ALARM_STATUS_MAP.keys}."
      }

      validates :month, inclusion: {
        in: 1..12,
        allow_nil: true,
        message: "%{value} is invalid!  Valid months are 1..12 and nil."
      }

      validates :day, inclusion: {
        if: ->(alarm) { alarm.month.nil? },
        in: 1..31,
        allow_nil: true,
        message: "%{value} is invalid!  Valid days are 1..31 and nil."
      }

      validates :day, inclusion: {
        if: ->(alarm) { alarm.day && alarm.month },
        in: ->(alarm) { VALID_DAYS_IN_MONTH[alarm.month] },
        message: ->(alarm, _attributes) do
          "#{alarm.day} is invalid for month #{alarm.month}!  " \
          "Valid days are #{VALID_DAYS_IN_MONTH[alarm.month]} and nil when month is #{alarm.month}."
        end
      }

      # Create an Alarm instance.
      #
      # @param number [Integer] Alarm number (from 1 to 5).
      # @param status [Symbol] Alarm status (:armed, :disarmed, or :unused).
      # @param time [::Time] Time of alarm.
      # @param message [String] Alarm message text.
      # @param month [Integer, nil] Month of alarm.
      # @param day [Integer, nil] Day of alarm.
      # @return [Alarm] Alarm instance.
      def initialize(number:, status:, time: DEFAULT_TIME, message: "", month: nil, day: nil)
        @number = number
        @status = status
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

        [
          [
            CPACKET_ALARM,
            number,
            time.hour,
            time.min,
            month.to_i,
            day.to_i,
            status_formatted,
            message_characters,
          ].flatten
        ]
      end

      private

      def message_characters
        protocol_6_chars_for(message, length: 16, pad: true)
      end

      def status_formatted
        ALARM_STATUS_MAP[status]
      end
    end
  end
end
