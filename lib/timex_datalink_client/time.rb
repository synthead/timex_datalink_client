# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Time
    include Helpers::CharEncoders
    prepend Helpers::CrcPacketsWrapper

    CPACKET_TIME = [0x32]

    attr_accessor :zone, :is_24h, :date_format, :time

    # Create a Time instance.
    #
    # @param zone [Integer] Time zone number (1 or 2).
    # @param is_24h [Boolean] Toggle 24 hour time.
    # @param date_format [Integer] Date format.
    # @param time [::Time] Time to set (including time zone).
    # @return [Time] Time instance.
    def initialize(zone:, is_24h:, date_format:, time:)
      @zone = zone
      @is_24h = is_24h
      @date_format = date_format
      @time = time
    end

    # Compile packets for a time.
    #
    # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
    def packets
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
          timezone_characters,
          wday_from_monday,
          is_24h_value,
          date_format
        ].flatten
      ]
    end

    private

    def timezone_characters
      chars_for(time.zone.downcase)
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
  end
end
