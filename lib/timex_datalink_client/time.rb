# frozen_string_literal: true

class TimexDatalinkClient
  class Time
    prepend Crc
    include CharEncoder

    CPACKET_TIME = [0x32]

    attr_accessor :zone, :is_24h, :date_format, :time

    def initialize(zone:, is_24h:, date_format:, time:)
      @zone = zone
      @is_24h = is_24h
      @date_format = date_format
      @time = time
    end

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
