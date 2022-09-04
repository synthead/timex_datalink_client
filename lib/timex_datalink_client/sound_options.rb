# frozen_string_literal: true

class TimexDatalinkClient
  class SoundOptions
    prepend Crc

    CPACKET_BEEPS = [0x71]

    attr_accessor :hourly_chimes, :button_beep

    def initialize(hourly_chimes:, button_beep:)
      @hourly_chimes = hourly_chimes
      @button_beep = button_beep
    end

    def packets
      [
        CPACKET_BEEPS + [hourly_chimes, button_beep]
      ]
    end
  end
end
