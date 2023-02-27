# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol6
    class Time
      include ActiveModel::Validations
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_TIME = [0x32].freeze
      CPACKET_FLEX_TIME = [0x33].freeze

      ZONE_OFFSET_MAP = {
        -39600 => 0x15,
        -36000 => 0x16,
        -32400 => 0x17,
        -28800 => 0x18,
        -25200 => 0x19,
        -21600 => 0x1a,
        -18000 => 0x1b,
        -14400 => 0x1c,
        -12600 => 0x14,
        -10800 => 0x1d,
        -7200 => 0x1e,
        -3600 => 0x1f,
        0 => 0x00,
        3600 => 0x01,
        7200 => 0x02,
        10800 => 0x03,
        12600 => 0x0d,
        14400 => 0x04,
        16200 => 0x0e,
        18000 => 0x05,
        19800 => 0x0f,
        20700 => 0x11,
        21600 => 0x06,
        23400 => 0x12,
        25200 => 0x07,
        28800 => 0x08,
        32400 => 0x09,
        34200 => 0x13,
        36000 => 0x0a,
        39600 => 0x0b,
        43200 => 0x0c
      }.freeze

      FLEX_TIME_ZONE = 0x10
      FLEX_DST_VALUE = 0x08

      DATE_FORMAT_MAP = {
        "%_m-%d-%y" => 0x00,
        "%_d-%m-%y" => 0x01,
        "%y-%m-%d" => 0x02,
        "%_m.%d.%y" => 0x04,
        "%_d.%m.%y" => 0x05,
        "%y.%m.%d" => 0x06
      }.freeze

      validates :zone, inclusion: {
        in: 1..2,
        message: "%{value} is invalid!  Valid zones are 1..2."
      }

      validates :date_format, inclusion: {
        in: DATE_FORMAT_MAP.keys,
        message: "%{value} is invalid!  Valid date formats are #{DATE_FORMAT_MAP.keys}."
      }

      validates :flex_time_zone, unless: :flex_time, inclusion: {
        in: [false],
        message: "cannot be enabled unless FLEXtime is also enabled."
      }

      validates :flex_dst, unless: :flex_time, inclusion: {
        in: [false],
        message: "cannot be enabled unless FLEXtime is also enabled."
      }

      attr_accessor :zone, :is_24h, :date_format, :time, :name, :flex_time, :flex_time_zone, :flex_dst

      # Create a Time instance.
      #
      # @param zone [Integer] Time zone number (1 or 2).
      # @param is_24h [Boolean] Toggle 24 hour time.
      # @param date_format ["%_m-%d-%y", "%_d-%m-%y", "%y-%m-%d", "%_m.%d.%y", "%_d.%m.%y", "%y.%m.%d"] Date format
      #   (represented by Time#strftime format).
      # @param time [::Time] Time to set (including time zone).
      # @param name [String, nil] Name of time zone (defaults to zone from time; 3 chars max).
      # @param flex_time [Boolean] Toggle using FLEXtime to set time and date.
      # @param flex_time_zone [Boolean] Toggle using FLEXtime to set time zone.
      # @param flex_dst [Boolean] Toggle using FLEXtime to apply daylight savings time offset.
      # @return [Time] Time instance.
      def initialize(
        zone:, is_24h:, date_format:, time:, name: nil, flex_time: false, flex_time_zone: false, flex_dst: false
      )
        @zone = zone
        @is_24h = is_24h
        @date_format = date_format
        @time = time
        @name = name
        @flex_time = flex_time
        @flex_time_zone = flex_time_zone
        @flex_dst = flex_dst
      end

      # Compile packets for a time.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [
          [
            cpacket,
            zone,
            second,
            hour,
            minute,
            month,
            day,
            year_mod_1900,
            name_characters,
            wday_from_monday,
            formatted_time_zone,
            is_24h_value,
            date_format_value
          ].flatten
        ]
      end

      private

      def cpacket
        flex_time ? CPACKET_FLEX_TIME : CPACKET_TIME
      end

      def second
        flex_time ? 0 : formatted_time.sec
      end

      def hour
        flex_time ? 0 : formatted_time.hour
      end

      def minute
        flex_time ? 0 : formatted_time.min
      end

      def month
        flex_time ? 0 : formatted_time.month
      end

      def day
        flex_time ? 0 : formatted_time.day
      end

      def formatted_name
        return name if name
        return time.zone if time.zone

        "TZ#{zone}"
      end

      def name_characters
        protocol_6_chars_for(formatted_name, length: 3, pad: true)
      end

      def year_mod_1900
        flex_time ? 0 : formatted_time.year % 100
      end

      def wday_from_monday
        flex_time ? 0 : (formatted_time.wday + 6) % 7
      end

      def formatted_time
        time.dst? ? time + 3600 : time
      end

      def formatted_utc_offset
        time.dst? ? time.utc_offset - 3600 : time.utc_offset
      end

      def formatted_time_zone
        flex_time_zone ? FLEX_TIME_ZONE : ZONE_OFFSET_MAP[formatted_utc_offset]
      end

      def is_24h_value
        is_24h ? 2 : 1
      end

      def date_format_value
        format = DATE_FORMAT_MAP.fetch(date_format)
        format += FLEX_DST_VALUE if flex_dst

        format
      end
    end
  end
end
