# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol1
    class Time
      prepend Helpers::CrcPacketsWrapper

      CPACKET_TIME = [0x30]

      attr_accessor :zone, :is_24h, :time

      # Create a Time instance.
      #
      # @param zone [Integer] Time zone number (1 or 2).
      # @param is_24h [Boolean] Toggle 24 hour time.
      # @param time [::Time] Time to set (including time zone).
      # @return [Time] Time instance.
      def initialize(zone:, is_24h:, time:)
        @zone = zone
        @is_24h = is_24h
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
            time.hour,
            time.min,
            time.month,
            time.day,
            year_mod_1900,
            wday_from_monday,
            time.sec,
            is_24h_value
          ].flatten
        ]
      end

      private

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
end
