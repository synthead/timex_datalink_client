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
        CPACKET_BEEPS + [hourly_chime, button_beep]
      ]
    end
  end
end
