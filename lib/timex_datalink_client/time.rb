# frozen_string_literal: true

class TimexDatalinkClient
  class Time
    prepend Crc
    include CharEncoder

    CPACKET_TIME = "\x32"
    TIME_OFFSET = 3.0

    attr_accessor :zone, :is_24h, :date_format

    def initialize(zone:, is_24h:, date_format:, time: nil)
      @zone = zone
      @is_24h = is_24h
      @date_format = date_format
      @time = time
    end

    def render
      CPACKET_TIME + time_array.pack("C*")
    end

    private

    def time_array
      [
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
    end

    def time
      @time ||= time_now_synced
    end

    def time_now_synced
      offset_time = ::Time.now + TIME_OFFSET.ceil

      sleep(1 - TIME_OFFSET % 1) unless TIME_OFFSET == TIME_OFFSET.to_i

      seconds = offset_time.usec / 1000000.0

      unless seconds.zero?
        offset_time += 1
        sleep(1 - seconds)
      end

      offset_time
    end

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
