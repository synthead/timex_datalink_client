# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol4
    class Time
      include ActiveModel::Validations
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_TIME = [0x32]

      DATE_FORMAT_MAP = {
        "%_m-%d-%y" => 0,
        "%_d-%m-%y" => 1,
        "%y-%m-%d" => 2,
        "%_m.%d.%y" => 4,
        "%_d.%m.%y" => 5,
        "%y.%m.%d" => 6
      }.freeze

      validates :zone, inclusion: {
        in: 1..2,
        message: "%{value} is invalid!  Valid zones are 1..2."
      }

      validates :date_format, inclusion: {
        in: DATE_FORMAT_MAP.keys,
        message: "%{value} is invalid!  Valid date formats are #{DATE_FORMAT_MAP.keys}."
      }

      attr_accessor :zone, :is_24h, :date_format, :time

      # Create a Time instance.
      #
      # @param zone [Integer] Time zone number (1 or 2).
      # @param is_24h [Boolean] Toggle 24 hour time.
      # @param date_format ["%_m-%d-%y", "%_d-%m-%y", "%y-%m-%d", "%_m.%d.%y", "%_d.%m.%y", "%y.%m.%d"] Date format
      #   (represented by Time#strftime format).
      # @param time [::Time] Time to set (including time zone).
      # @param name [String, nil] Name of time zone (defaults to zone from time; 3 chars max).
      # @return [Time] Time instance.
      def initialize(zone:, is_24h:, date_format:, time:, name: nil)
        @zone = zone
        @is_24h = is_24h
        @date_format = date_format
        @time = time
        @name = name
      end

      # Compile packets for a time.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [
          [
            CPACKET_TIME,
            zone,
            time.sec,
            time.hour,
            time.min,
            time.month,
            time.day,
            year_mod_1900,
            name_characters,
            wday_from_monday,
            is_24h_value,
            date_format_value
          ].flatten
        ]
      end

      private

      def name
        @name || time.zone || "tz#{zone}"
      end

      def name_characters
        chars_for(name, length: 3, pad: true)
      end

      def year_mod_1900
        time.year % 100
      end

      def wday_from_monday
        (time.wday + 6) % 7
      end

      def is_24h_value
        is_24h ? 2 : 1
      end

      def date_format_value
        DATE_FORMAT_MAP.fetch(date_format)
      end
    end
  end
end
