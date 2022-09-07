# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class SoundOptions
    prepend Helpers::CrcPacketsWrapper

    CPACKET_BEEPS = [0x71]

    attr_accessor :hourly_chime, :button_beep

    def initialize(hourly_chime:, button_beep:)
      @hourly_chime = hourly_chime
      @button_beep = button_beep
    end

    def packets
      [
        CPACKET_BEEPS + [hourly_chime_integer, button_beep_integer]
      ]
    end

    def hourly_chime_integer
      hourly_chime ? 1 : 0
    end

    def button_beep_integer
      button_beep ? 1 : 0
    end
  end
end
