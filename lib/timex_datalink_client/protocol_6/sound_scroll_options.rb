# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol6
    class SoundScrollOptions
      include ActiveModel::Validations
      prepend Helpers::CrcPacketsWrapper

      CPACKET_SOUND_SCROLL = 0x71

      validates :scroll_speed, inclusion: {
        in: 0..2,
        message: "%{value} is invalid!  Valid scroll speed values are 0..2."
      }

      attr_accessor :hourly_chime, :button_beep, :scroll_speed

      # Create a SoundScrollOptions instance.
      #
      # @param hourly_chime [Boolean] Toggle hourly chime.
      # @param button_beep [Boolean] Toggle button beep.
      # @param scroll_speed [Integer] Message scroll speed (0 to 2).
      # @return [SoundScrollOptions] SoundScrollOptions instance.
      def initialize(hourly_chime: false, button_beep: false, scroll_speed: 1)
        @hourly_chime = hourly_chime
        @button_beep = button_beep
        @scroll_speed = scroll_speed
      end

      # Compile packets for sound and scroll options.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [
          [
            CPACKET_SOUND_SCROLL,
            hourly_chime_formatted,
            button_beep_formatted,
            scroll_speed
          ]
        ]
      end

      def hourly_chime_formatted
        hourly_chime ? 1 : 0
      end

      def button_beep_formatted
        button_beep ? 1 : 0
      end
    end
  end
end
