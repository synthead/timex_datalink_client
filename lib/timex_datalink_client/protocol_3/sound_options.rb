# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol3
    class SoundOptions
      prepend Helpers::CrcPacketsWrapper

      CPACKET_BEEPS = [0x71]

      attr_accessor :hourly_chime, :button_beep

      # Create a SoundOptions instance.
      #
      # @param hourly_chime [Boolean] Toggle hourly chime sounds.
      # @param button_beep [Boolean] Toggle button beep sounds.
      # @return [SoundOptions] SoundOptions instance.
      def initialize(hourly_chime:, button_beep:)
        @hourly_chime = hourly_chime
        @button_beep = button_beep
      end

      # Compile packets for sound options.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
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
end
